import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            fileName,
            style: GoogleFonts.poppins(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.black,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.grey),
        ),
        body: Consumer<PlayerProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      provider.isPlaying ? 
                      Lottie.asset(
                        'assets/animations/player.json',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ) : SizedBox() , 
                      // Icon(Icons.text_decrease_outlined , color: Colors.white,) , 
                      // Image.asset('assets/animations/speech-synthesis.png' , width: 60, height: 60, fit: BoxFit.contain,) , 
                      // TextButton(onPressed: , child: Text("Generate")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                        value: provider.progress,
                        onChanged: (value) => provider.seekTo(value),
                        min: 0.0,
                        max: 1.0,
                        activeColor: const Color.fromARGB(255, 249, 22, 14),
                        inactiveColor: Colors.grey.shade300,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.currentPosition != null
                                  ? _formatDuration(provider.currentPosition!)
                                  : "00:00",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              provider.totalDuration != null
                                  ? _formatDuration(provider.totalDuration!)
                                  : "00:00",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => provider.playPause(filePath),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          width: 40, // Adjust size for the circular button
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.isPlaying
                                ? const Color.fromARGB(255, 249, 22, 14)
                                : const Color.fromARGB(255, 249, 22, 14),
                          ),
                          child: Center(
                            child: Icon(
                              provider.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 25, // Icon size
                              color: Colors.white, // Icon color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment
                      .bottomCenter, // Align to the bottom-center of the screen
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 40), // Margin from the bottom
                    child: Stack(
                      children: [
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: PopupMenuButton<double>(
                            onSelected: (speed) =>
                                provider.setPlaybackSpeed(speed),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 0.5,
                                child: Text("0.5x"),
                              ),
                              const PopupMenuItem(
                                value: 1.0,
                                child: Text("1.0x"),
                              ),
                              const PopupMenuItem(
                                value: 1.5,
                                child: Text("1.5x"),
                              ),
                              const PopupMenuItem(
                                value: 2.0,
                                child: Text("2.0x"),
                              ),
                            ],
                            child: Row(
                              children: [
                                Text(
                                  "${provider.speed}x",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 249, 22, 14),
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: Color.fromARGB(255, 249, 22, 14)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
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
