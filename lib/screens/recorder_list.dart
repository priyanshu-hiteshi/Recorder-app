import 'package:chatapp/models/all_audios_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/recorder_provider.dart';
import '../provider/dialog_provider.dart';
import 'player_screen.dart';

class RecorderListScreen extends StatefulWidget {
  const RecorderListScreen({super.key});

  @override
  _RecorderListScreenState createState() => _RecorderListScreenState();
}

class _RecorderListScreenState extends State<RecorderListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the fetchRecordings function as the screen loads
    final recorderProvider =
        Provider.of<RecorderProvider>(context, listen: false);
    recorderProvider.fetchRecordings();
  }

  @override
  Widget build(BuildContext context) {
    // final dialogProvider = Provider.of<DialogProvider>(context, listen: false);
    final recorderProvider = Provider.of<RecorderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Recordings',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: Consumer<RecorderProvider>(
        builder: (context, recorderProvider, child) {
          final recordings = recorderProvider.recordings;

          if (recordings.isEmpty) {
            return const Center(
              child: Text(
                "No recordings found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final recording = recordings[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color.fromRGBO(248, 141, 141, 1),
                      child: Icon(Icons.audiotrack, color: Colors.white),
                    ),
                    title: Text(
                      recording.filename,
                    

                       style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 183, 182, 182), fontWeight: FontWeight.w600, fontSize: 14,),

                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'Rename') {
                          recorderProvider.renameRecording(context, recording);
                        } else if (value == 'Delete') {
                          recorderProvider.deleteRecording(context, recording);
                        } else if (value == 'Generate') {
                          recorderProvider.generateRecordingData(
                              context, recording);
                        } else if (value == 'Show') {
                        recorderProvider.showSummary(context, recording);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Rename',
                          child: Text('Rename'),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                        PopupMenuItem(
                          value: recording.summariesText.isNotEmpty
                              ? 'Show'
                              : 'Generate',
                          child: Text(
                            recording.summariesText.isNotEmpty
                                ? 'Show Summary'
                                : 'Generate',
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            filePath: recording.fileUrl,
                            fileName: recording.filename,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
