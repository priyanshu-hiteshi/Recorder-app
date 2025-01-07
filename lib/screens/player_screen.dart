import 'package:chatapp/models/generate_text_model.dart';
import 'package:chatapp/provider/recorder_provider.dart';
import 'package:chatapp/widgets/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import '../provider/player_provider.dart';
import '../models/all_audios_model.dart';
import 'dart:ui';

class PlayerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final AllAudio recording;
  // final GenerateSummary generateSummary ;

  const PlayerScreen({
    required this.filePath,
    required this.fileName,
    required this.recording,
    // required this.generateSummary ,
    Key? key,
  }) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  String _transcript = "";
  String _summary = "";
  bool clickeOrnot = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(
            create: (_) => RecorderProvider()), // Add RecorderProvider
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
              Flexible(
                child: Text(
                  widget.fileName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
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
                            _transcript =
                                recorderProvider.transcriptFromprovider==null  
                                    ? "Transcription not found"
                                    : recorderProvider.transcriptFromprovider!;
                            _summary = "";
                            clickeOrnot = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10.3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Transcript',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              decoration: _transcript.isNotEmpty && clickeOrnot
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _summary = (recorderProvider
                                        .summaryFromprovider!.isNotEmpty &&
                                    recorderProvider.isGenerated
                                ? recorderProvider.summaryFromprovider
                                : "Summary not found")!;
                            _transcript = "";
                            clickeOrnot = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Summary',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              decoration: _transcript.isEmpty && clickeOrnot
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                // Scrollable container for the transcript/summary
                recorderProvider.isGenerated && clickeOrnot
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20),
                        margin: const EdgeInsets.fromLTRB(20, 60, 20, 1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(
                                    0.1), // Adjust opacity for glass effect
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 400, // Adjust height as needed
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        _transcript.isNotEmpty
                                            ? _transcript
                                            : _summary, // Show either transcript or summary
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16), // Add spacing
                                  Text(
                                    'Number of Speakers: ${recorderProvider.numberOfspeackers}',
                                    style: GoogleFonts.poppins(
                                      color: const Color.fromARGB(
                                              255, 177, 176, 176)
                                          .withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(" "),
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
                                  ? _formatDuration(
                                      playerProvider.currentPosition!)
                                  : "00:00",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              playerProvider.totalDuration != null
                                  ? _formatDuration(
                                      playerProvider.totalDuration!)
                                  : "00:00",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => playerProvider.playPause(widget.filePath),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          width: 60,
                          height: 60,
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
                              size: 35,
                              color: Colors.white,
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
                                playerProvider.setPlaybackSpeed(speed),
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
                                  "${playerProvider.speed}x",
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
