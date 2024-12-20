import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';

class PlayerProvider extends ChangeNotifier {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool isPlaying = false;
  double progress = 0.0;
  double speed = 1.0;
  Duration? totalDuration;
  Duration? currentPosition;

  PlayerProvider() {
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
    _player.setSubscriptionDuration(const Duration(milliseconds: 500));
    _player.onProgress?.listen((event) {
      currentPosition = event.position;
      totalDuration = event.duration;
      progress = (currentPosition?.inMilliseconds ?? 0) /
          (totalDuration?.inMilliseconds ?? 1);
      notifyListeners();
    });
  }

  Future<void> playPause(String filePath) async {
  if (isPlaying) {
    // Pause the playback instead of stopping
    await _player.pausePlayer();
  } else {
    // Start or resume playback
    await _player.startPlayer(
      fromURI: filePath,
      codec: Codec.defaultCodec,
      whenFinished: () {
        isPlaying = false;
        progress = 0.0;
        notifyListeners();
      },
    );
    _player.setSpeed(speed);
  }
  isPlaying = !isPlaying;
  notifyListeners();
}


  Future<void> stopPlayback() async {
    await _player.stopPlayer();
    isPlaying = false;
    progress = 0.0;
    notifyListeners();
  }

  void setPlaybackSpeed(double newSpeed) {
    speed = newSpeed;
    _player.setSpeed(speed);
    notifyListeners();
  }

  Future<void> seekTo(double value) async {
    if (totalDuration != null) {
      final newPosition = Duration(
          milliseconds:
              (value * (totalDuration!.inMilliseconds)).toInt());
      await _player.seekToPlayer(newPosition);
    }
  }

  @override
  void dispose() {
    _player.stopPlayer();
    _player.closePlayer();
    super.dispose();
  }
}
