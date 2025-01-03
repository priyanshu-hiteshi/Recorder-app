import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/models/all_audios_model.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:chatapp/models/generate_text_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RecorderProvider with ChangeNotifier {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? recordingFilePath;
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;
  bool isGenerated = false;
  int secondsElapsed = 0;
  String timerText = "00:00";
  Timer? _timer;
  int pausedAt = 0;
  List<AllAudio> _recordings = [];

  List<AllAudio> get recordings => _recordings;
  bool isLoading = false;

  RecorderProvider() {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
  }

  Future<void> initRecorder() async {
    await _recorder?.openRecorder();
    await _player?.openPlayer();
  }

  Future<bool> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      final result = await Permission.microphone.request();
      if (result.isGranted) {
        return true;
      } else {
        throw Exception("Microphone permission is required to record audio.");
      }
    }
    return false;
  }

  Future<void> startRecording() async {
    try {
      final hasPermission = await _checkMicrophonePermission();
      if (!hasPermission) {
        return;
      }

      final Directory directory = await getApplicationDocumentsDirectory();
      recordingFilePath =
          "${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac";
      await _recorder?.startRecorder(toFile: recordingFilePath);
      isRecording = true;
      isPaused = false;
      pausedAt = 0;
      secondsElapsed = 0;
      timerText = "00:00";

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isPaused) {
          secondsElapsed++;
        }
        final minutes = (secondsElapsed ~/ 60).toString().padLeft(2, '0');
        final seconds = (secondsElapsed % 60).toString().padLeft(2, '0');
        timerText = "$minutes:$seconds";
        notifyListeners();
      });

      notifyListeners();
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    await _recorder?.stopRecorder();
    isRecording = false;
    isPaused = false;
    _timer?.cancel();
    notifyListeners();
  }

  Future<void> pauseRecording() async {
    await _recorder?.pauseRecorder();
    isPaused = true;
    pausedAt = secondsElapsed;
    notifyListeners();
  }

  Future<void> resumeRecording() async {
    await _recorder?.resumeRecorder();
    isPaused = false;
    secondsElapsed = pausedAt; // Resume from where it was paused
    notifyListeners();
  }

  Future<void> fetchRecordings() async {
    isLoading = true; // Start loading
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${EndPoints.fetchfiles}'),
      );

      if (response.statusCode == 200) {
        final messageModel = MessageModel.fromJson(json.decode(response.body));
        if (messageModel.success) {
          _recordings = messageModel.allAudios;
          print(messageModel.allAudios);
        } else {
          throw Exception(
              "Failed to fetch recordings: ${messageModel.message}");
        }
      } else {
        throw Exception(
            "Failed to load recordings. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching recordings: $e");
      throw Exception("Error fetching recordings");
    } finally {
      isLoading = false; // Stop loading
      notifyListeners();
    }
  }

  //  Future<void> deleteSelectedRecordings(List<int> fileIds) async {
  //   try {
  //     final response = await ApiService.deleteRequest(
  //       endPoint: "/api/file/deleteMultipleAudioFiles",
  //       headers: {'Content-Type': 'application/json'},
  //       body: {"fileIds": fileIds},
  //     );

  //     if (response.statusCode == 200) {
  //       // Remove deleted recordings locally
  //       recordings.removeWhere((recording) => fileIds.contains(recording.id));
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print("Failed to delete recordings: $e");
  //     throw Exception("Failed to delete recordings");
  //   }
  // }

  Future<void> deleteSelectedRecordings(List<int> fileIds) async {
    try {
      final String url = '${AppConfig.baseUrl}${EndPoints.deleteMultipleFiles}';

      final Map<String, dynamic> body = {
        "fileIds": fileIds,
      };

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Deleted successfully");
        recordings.removeWhere((recording) => fileIds.contains(recording.id));
        notifyListeners();
      } else {
        throw Exception('Failed to delete the files ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred ${e.toString()}');
    }
  }

  Future<void> uploadRecordingToServer(String filePath, String title) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}${EndPoints.fileUpload}'),
      );

      // Add the file to the request
      var file = await http.MultipartFile.fromPath(
        'audioFile', // Key for the file in the request
        filePath,
      );
      request.files.add(file);

      // Add additional fields to the request
      request.fields['fileName'] = title;

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        print("File uploaded successfully!");
      } else {
        print("File upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading file: $e");
      throw Exception("Failed to upload recording");
    }
  }

  Future<void> saveRecordingWithTitleAndUpload(String title) async {
    if (recordingFilePath != null) {
      try {
        // Save locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> recordings =
            prefs.getStringList(LocalPoint.recordings) ?? [];
        recordings.add('$title|$recordingFilePath');
        await prefs.setStringList(LocalPoint.recordings, recordings);

        print("Recordings saved locally: $recordings");

        // Upload to server
        print("Uploading recording to server...");
        await uploadRecordingToServer(recordingFilePath!, title);
        print("Recording uploaded successfully!");

        // Reset recorder state
        resetRecorderState();
        print("Recorder state reset.");
      } catch (e) {
        // Handle errors gracefully
        print("Error in saving or uploading recording: $e");
        throw Exception("Failed to save or upload recording.");
      }
    } else {
      print("No recording file path available to save or upload.");
      throw Exception("Recording file path is null.");
    }
  }

  Future<void> playRecording(String filePath) async {
    if (isPlaying) {
      await stopPlayback();
    } else {
      await _player?.startPlayer(
        fromURI: filePath,
        codec: Codec.aacADTS,
        whenFinished: () {
          isPlaying = false;
          notifyListeners();
        },
      );
      isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> stopPlayback() async {
    await _player?.stopPlayer();
    isPlaying = false;
    notifyListeners();
  }

  void resetRecorderState() {
    secondsElapsed = 0;
    timerText = "00:00";
    recordingFilePath = null;
    pausedAt = 0;
    notifyListeners();
  }

  Future<bool> renameAudioFile(int recordingId, String newName) async {
    try {
      // API endpoint
      final String url =
          '${AppConfig.baseUrl}${EndPoints.renameFile}$recordingId';

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
        return true; // Success
      } else {
        throw Exception(
            'Failed to rename the recording. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  // Future<void> renameRecording(BuildContext context, AllAudio recording) async {
  //   TextEditingController controller =
  //       TextEditingController(text: recording.filename);

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Rename Recording',
  //           style: GoogleFonts.poppins(
  //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //         content: TextField(
  //           controller: controller,
  //           decoration: const InputDecoration(
  //             labelText: 'New Name',
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               'Cancel',
  //               style: GoogleFonts.poppins(
  //                   color: Colors.red, fontWeight: FontWeight.w400),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               String newName = controller.text.trim();

  //               if (newName.isEmpty) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Name cannot be empty')),
  //                 );
  //                 return;
  //               }

  //               Navigator.pop(context); // Close the dialog

  //               try {
  //                 // API endpoint
  //                 final String url =
  //                     '${AppConfig.baseUrl}${EndPoints.renameFile}${recording.id}';

  //                 // Request payload
  //                 final Map<String, String> body = {
  //                   "newName": newName,
  //                 };

  //                 // API call
  //                 final response = await http.put(
  //                   Uri.parse(url),
  //                   headers: {
  //                     "Content-Type": "application/json",
  //                   },
  //                   body: jsonEncode(body),
  //                 );

  //                 if (response.statusCode == 200) {
  //                   // Update local filename and notify listeners
  //                   recording.filename = newName;
  //                   notifyListeners();

  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                         content: Text('Recording renamed successfully!')),
  //                   );

  //                   await fetchRecordings();
  //                 } else {
  //                   // Handle server errors
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text(
  //                           'Failed to rename the recording. Status code: ${response.statusCode}'),
  //                     ),
  //                   );
  //                 }
  //               } catch (e) {
  //                 // Handle connection errors
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text('An error occurred: ${e.toString()}'),
  //                   ),
  //                 );
  //               }
  //             },
  //             child: Text(
  //               'Rename',
  //               style: GoogleFonts.poppins(
  //                   color: Colors.black, fontWeight: FontWeight.w400),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> deleteRecording(BuildContext context, AllAudio recording) async {
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
                notifyListeners();
                isLoading = true;

                if (response.statusCode == 200) {
                  isLoading = false;
                  _recordings.removeWhere((r) => r.id == recording.id);
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
    AllAudio recording,
  ) async {
    try {
      

      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}${EndPoints.generateSummary}${recording.id}',
        ),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          isGenerated = true  ; 
          notifyListeners() ; 
          final decodedJson = json.decode(response.body);

          if (decodedJson != null && decodedJson is Map<String, dynamic>) {
            final messageModel = GenerateTextMessage.fromJson(decodedJson);

            
            print(
                'Generated summary: ${messageModel.generateSummary.transcript}');
            print(
                'Number of Speakers: ${messageModel.generateSummary.speakers}');

            
          } else {
            print('Invalid JSON format');
            showSnackBar(context, 'Failed to parse response data');
          }
        } else {
          print('Response body is empty');
          showSnackBar(context, 'No data received');
        }

        // await fetchRecordings();
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

  Future<void> showSummary(BuildContext context, AllAudio recording) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Summary',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: 200.0, // Set height
          width: 400.0, // Set width
          child: SingleChildScrollView(
            child: Text(
              recording.summariesText,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
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

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }
}
