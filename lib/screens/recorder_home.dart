import 'package:chatapp/screens/recorder_list.dart';
import 'package:chatapp/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/recorder_provider.dart';
import '../widgets/custom_modal.dart';

class RecorderHome extends StatelessWidget {
  const RecorderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final recorderProvider =
        Provider.of<RecorderProvider>(context, listen: false);

    return FutureBuilder(
      
      future: recorderProvider.initRecorder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }

        return Scaffold(
          body: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer display
              Center(
                child: Consumer<RecorderProvider>(
                  builder: (context, provider, child) => Text(
                    provider.timerText,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Mic (Start Recording) Icon Button
                Consumer<RecorderProvider>(
                  builder: (context, provider, child) {
                    return GestureDetector(
                      onTap: () async {
                        if (provider.isRecording) {
                          await provider.stopRecording();
                        } else {
                          await provider.startRecording();
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: provider.isRecording
                            ? Colors.red // For recording state
                            : const Color(0xFF2575FC), // For stopped state
                        radius: 30,
                        child: Icon(
                          provider.isRecording ? Icons.stop : Icons.mic,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                // Play/Pause Toggle Button
                Consumer<RecorderProvider>(
                  builder: (context, provider, child) {
                    return GestureDetector(
                      onTap: () async {
                        if (provider.isRecording) {
                          if (provider.isPaused) {
                            // Resume recording
                            await provider.resumeRecording();
                          } else {
                            // Pause recording
                            await provider.pauseRecording();
                          }
                        }
                      },
                      child: provider.isRecording
                          ? CircleAvatar(
                              backgroundColor:
                                  Colors.white, // Red color for both states
                              radius: 30,
                              child: Icon(
                                provider.isPaused
                                    ? Icons.play_arrow
                                    : Icons
                                        .pause, // Toggle between play and pause
                                size: 32,
                                color: Colors.black,
                              ),
                            )
                          : Text(""),
                    );
                  },
                ),

                // Save or List Icon
                Consumer<RecorderProvider>(
                  builder: (context, provider, child) {
                    if (!provider.isRecording && provider.secondsElapsed > 0) {
                      return ElevatedButton(
                        onPressed: () {
                          _showSaveModal(context, provider);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Icon(
                          Icons.done,
                          color: Colors.black,
                          size: 30,
                        ),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecorderListScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Icon(
                          Icons.list,
                          color: Colors.black,
                          size: 30,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSaveModal(BuildContext context, RecorderProvider provider) {
    TextEditingController titleController = TextEditingController();
    titleController.text =
        "Recording ${DateTime.now().toString().substring(0, 19)}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaveRecordingModal(
          titleController: titleController,
          onCancel: () {
            Navigator.pop(context);
            provider.resetRecorderState();
          },
          onSave: () async {
            await provider.saveRecordingWithTitle(titleController.text);
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recording saved successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
            provider.resetRecorderState();
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
