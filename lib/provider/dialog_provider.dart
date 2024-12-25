import 'dart:convert';

import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/models/generate_text_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/models/all_audios_model.dart' as allAudios;
import 'package:chatapp/models/generate_text_model.dart' as generateText;

class DialogProvider extends ChangeNotifier {
  Future<void> renameRecording(
      BuildContext context, allAudios.AllAudio recording) async {
    TextEditingController controller =
        TextEditingController(text: recording.filename);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Recording'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'New Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add renaming logic here if needed
                Navigator.pop(context);
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteRecording(
      BuildContext context, allAudios.AllAudio recording) async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recording'),
        content: Text(
          'Are you sure you want to delete "${recording.filename}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog
              Navigator.pop(context);

              try {
                final String url =
                    '${AppConfig.baseUrl}${EndPoints.deleteFile}${recording.id}';

                final response = await http.delete(Uri.parse(url));

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Recording deleted successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete the recording!')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Error occurred while deleting the recording!')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> generateRecordingData(
  BuildContext context, 
  allAudios.AllAudio recording,
) async {
  try {
    final response = await http.get(
      Uri.parse(
        '${AppConfig.baseUrl}${EndPoints.generateSummary}${recording.id}',
      ),
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final decodedJson = json.decode(response.body);

        if (decodedJson != null && decodedJson is Map<String, dynamic>) {
          final messageModel = GenerateTextMessage.fromJson(decodedJson);

          // Show modal dialog with the generated text
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Generated Summary'),
              content: SingleChildScrollView(
                child: Text(
                  messageModel.generateSummary.summariesText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          print('Invalid JSON format');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to parse response data')),
          );
        }
      } else {
        print('Response body is empty');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data received')),
        );
      }
    } else {
      print('Failed to generate data. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to generate data. Status code: ${response.statusCode}',
          ),
        ),
      );
    }
  } catch (e) {
    print('An error occurred: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred while generating data')),
    );
  }
}


  Future<void> showSummary(
      BuildContext context, allAudios.AllAudio recording) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Summary'),
        content: Text(recording.summariesText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
