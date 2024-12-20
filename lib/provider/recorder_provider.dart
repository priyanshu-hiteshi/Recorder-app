import 'dart:async';
import 'dart:io';
import 'package:chatapp/helper/local_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> saveRecordingWithTitle(String title) async {
    if (recordingFilePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> recordings = prefs.getStringList(LocalPoint.recordings) ?? [];
      recordings.add('$title|$recordingFilePath');
      await prefs.setStringList(LocalPoint.recordings, recordings);
      resetRecorderState();
    }
  }

  Future<List<String>> getRecordings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(LocalPoint.recordings) ?? [];
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
