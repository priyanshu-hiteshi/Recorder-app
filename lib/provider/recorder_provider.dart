import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/models/all_audios_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class RecorderProvider with ChangeNotifier {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? recordingFilePath;
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;
  int secondsElapsed = 0;
  String timerText = "00:00";
  Timer? _timer;
  int pausedAt = 0;
  List<AllAudio> _recordings = [];

  List<AllAudio> get recordings => _recordings;

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
  try {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}${EndPoints.fetchfiles}'),
    );

    if (response.statusCode == 200) {
      final messageModel = MessageModel.fromJson(json.decode(response.body));
      if (messageModel.success) {
        _recordings = messageModel.allAudios;
        print(messageModel.allAudios) ; 
        notifyListeners();
      } else {
        throw Exception("Failed to fetch recordings: ${messageModel.message}");
      }
    } else {
      throw Exception("Failed to load recordings. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching recordings: $e");
    throw Exception("Error fetching recordings");
  }
}



  

  Future<void> uploadRecordingToServer(String filePath, String title) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}${EndPoints.fileUpload}'),
      );

      var file = await http.MultipartFile.fromPath("audioFile", filePath);
      request.files.add(file);

      request.fields['title'] = title;

      var response = await request.send();

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
      // Save locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> recordings =
          prefs.getStringList(LocalPoint.recordings) ?? [];
      recordings.add('$title|$recordingFilePath');
      await prefs.setStringList(LocalPoint.recordings, recordings);

      // Upload to server
      await uploadRecordingToServer(recordingFilePath!, title);

      // Reset recorder state
      resetRecorderState();
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

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }
}
