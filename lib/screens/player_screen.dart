import 'package:chatapp/provider/recorder_provider.dart';
import 'package:chatapp/widgets/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import '../provider/player_provider.dart';
import '../models/all_audios_model.dart';

class PlayerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final AllAudio recording;

  const PlayerScreen({
    required this.filePath,
    required this.fileName,
    required this.recording,
    Key? key,
  }) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  String _transcript = "";  // To store the transcript
  String _summary = "";     // To store the summary

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => RecorderProvider()), // Add RecorderProvider
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.fileName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              AnimatedGradientButton(
                recording: widget.recording,
              ),
            ],
          ),
        ),
        body: Consumer2<PlayerProvider, RecorderProvider>(
          builder: (context, playerProvider, recorderProvider, child) {
            return Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                if (recorderProvider.isGenerated) ...[
                  // Render Transcript and Summary Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _transcript = "gygygygygyg yfgyfyfyf yfyfyfyf yfyfyfyfyfygguyggy yfyfytfdfyfyfyfygyygyg yfgyffyfyfyf yfyfygbgygy yfyfyfygygbyvy yfyfyfy"; // Assuming recorderProvider has a transcript
                            _summary = ""; // Clear summary if transcript is clicked
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10.3),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Transcript',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _summary = "gugugugugugugugugu ugugugu ugugugugugu ugugugugugugugu  gugugugugugugu ugugugugugugugu ugugu ugu"; // Assuming recorderProvider has a summary
                            _transcript = ""; // Clear transcript if summary is clicked
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Summary',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                // Scrollable container for the transcript/summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 200,  // Adjust height as needed
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Text(
                        _transcript.isNotEmpty ? _transcript : _summary, // Show either transcript or summary
                        style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                        value: playerProvider.progress,
                        onChanged: (value) => playerProvider.seekTo(value),
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
                              playerProvider.currentPosition != null
                                  ? _formatDuration(playerProvider.currentPosition!)
                                  : "00:00",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              playerProvider.totalDuration != null
                                  ? _formatDuration(playerProvider.totalDuration!)
                                  : "00:00",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => playerProvider.playPause(widget.filePath),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: playerProvider.isPlaying
                                ? const Color.fromARGB(255, 249, 22, 14)
                                : const Color.fromARGB(255, 249, 22, 14),
                          ),
                          child: Center(
                            child: Icon(
                              playerProvider.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
