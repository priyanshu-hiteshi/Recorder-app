import 'dart:convert';

import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/models/all_audios_model.dart';
import 'package:chatapp/models/generate_text_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/models/all_audios_model.dart' as allAudios;
import 'package:chatapp/models/generate_text_model.dart' as generateText;

class DialogProvider extends ChangeNotifier {
  List<allAudios.AllAudio> recordings = [];
  bool isLoading = false;

  Future<void> renameRecording(
      BuildContext context, allAudios.AllAudio recording) async {
    TextEditingController controller =
        TextEditingController(text: recording.filename);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Rename Recording',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
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
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    color: Colors.red, fontWeight: FontWeight.w400),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newName = controller.text.trim();

                if (newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty')),
                  );
                  return;
                }

                Navigator.pop(context); // Close the dialog

                try {
                  // API endpoint
                  final String url =
                      '${AppConfig.baseUrl}${EndPoints.renameFile}${recording.id}';

                  // Request payload
                  final Map<String, String> body = {
                    "newName": newName,
                  };

                  // API call
                  final response = await http.put(
                    Uri.parse(url),
                    headers: {
                      "Content-Type": "application/json",
                    },
                    body: jsonEncode(body),
                  );

                  if (response.statusCode == 200) {
                    // Update local filename and notify listeners
                    recording.filename = newName;
                    notifyListeners();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Recording renamed successfully!')),
                    );
                  } else {
                    // Handle server errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Failed to rename the recording. Status code: ${response.statusCode}'),
                      ),
                    );
                  }
                } catch (e) {
                  // Handle connection errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('An error occurred: ${e.toString()}'),
                    ),
                  );
                }
              },
              child: Text(
                'Rename',
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w400),
              ),
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
        title: Text(
          'Delete Recording',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "${recording.filename}"?',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                  color: Colors.red, fontWeight: FontWeight.w400),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog
              Navigator.pop(context);

              try {
                final String url =
                    '${AppConfig.baseUrl}${EndPoints.deleteFile}${recording.id}';

                final response = await http.delete(Uri.parse(url));
                isLoading = true;

                if (response.statusCode == 200) {
                  isLoading = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Recording deleted successfully!')),
                  );
                } else {
                  isLoading = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete the recording!')),
                  );
                }
              } catch (e) {
                isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Error occurred while deleting the recording!')),
                );
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );

    notifyListeners();
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
                title: Text(
                  'Generated Summary',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      Text(
                        messageModel.generateSummary.summariesText,
                        style: GoogleFonts.poppins(
                          // Use any Google font here
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                          height: 10), // Add spacing between the texts
                      Text(
                        'Number of Speakers: ${messageModel.generateSummary.speakers}',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
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
        const SnackBar(
            content: Text('An error occurred while generating data')),
      );
    }
  }

  Future<void> showSummary(
      BuildContext context, allAudios.AllAudio recording) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Summary',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          recording.summariesText,
          style: GoogleFonts.poppins(
            // Use any Google font here
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
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
