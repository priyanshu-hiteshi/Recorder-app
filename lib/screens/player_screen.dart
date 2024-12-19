import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const PlayerScreen({required this.filePath, required this.fileName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(fileName),
          backgroundColor: const Color(0xFF2575FC),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PlayerProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Slider(
                    value: provider.progress,
                    onChanged: (value) => provider.seekTo(value),
                    min: 0.0,
                    max: 1.0,
                    activeColor: const Color(0xFF2575FC),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.currentPosition != null
                            ? _formatDuration(provider.currentPosition!)
                            : "00:00",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        provider.totalDuration != null
                            ? _formatDuration(provider.totalDuration!)
                            : "00:00",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          provider.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 48,
                          color: const Color(0xFF2575FC),
                        ),
                        onPressed: () => provider.playPause(filePath),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(
                          Icons.stop,
                          size: 48,
                          color: Colors.red,
                        ),
                        onPressed: provider.stopPlayback,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Playback Speed",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => provider.setPlaybackSpeed(0.5),
                        child: const Text("0.5x"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => provider.setPlaybackSpeed(1.0),
                        child: const Text("1.0x"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => provider.setPlaybackSpeed(1.5),
                        child: const Text("1.5x"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => provider?.setPlaybackSpeed(2.0),
                        child: const Text("2.0x"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return "$minutes:$seconds";
  }
}
