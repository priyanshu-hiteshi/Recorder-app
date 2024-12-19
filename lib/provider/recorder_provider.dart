import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecorderProvider with ChangeNotifier {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? recordingFilePath;
  bool isRecording = false;
  bool isPlaying = false;
  int secondsElapsed = 0;
  String timerText = "00:00";
  Timer? _timer;

  RecorderProvider() {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
  }

  Future<void> initRecorder() async {
    await _recorder?.openRecorder();
    await _player?.openPlayer();
  }

  Future<void> startRecording() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    recordingFilePath = "${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac";
    await _recorder?.startRecorder(toFile: recordingFilePath);
    isRecording = true;
    secondsElapsed = 0;
    timerText = "00:00";

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsElapsed++;
      final minutes = (secondsElapsed ~/ 60).toString().padLeft(2, '0');
      final seconds = (secondsElapsed % 60).toString().padLeft(2, '0');
      timerText = "$minutes:$seconds";
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _recorder?.stopRecorder();
    isRecording = false;
    _timer?.cancel();
    notifyListeners();
  }

  Future<void> saveRecording() async {
    if (recordingFilePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> recordings = prefs.getStringList('recordings') ?? [];
      recordings.add(recordingFilePath!);
      await prefs.setStringList('recordings', recordings);
      resetRecorderState();
    }
  }

  Future<List<String>> getRecordings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recordings') ?? [];
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
    notifyListeners();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }
}
