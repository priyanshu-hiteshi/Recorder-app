import 'package:chatapp/screens/recorder_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/recorder_provider.dart';

class RecorderHome extends StatelessWidget {
  const RecorderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final recorderProvider = Provider.of<RecorderProvider>(context, listen: false);

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
                // Mic Icon Button
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
                        backgroundColor: provider.isRecording ? Colors.red : const Color(0xFF2575FC),
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

                // Save Button or List Icon
                Consumer<RecorderProvider>(
                  builder: (context, provider, child) {
                    if (!provider.isRecording && provider.secondsElapsed > 0) {
                      return ElevatedButton(
                        onPressed: () async {
                          await provider.saveRecording();
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recording saved successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          provider.resetRecorderState();
                        },
                        style: TextButton.styleFrom(
                          // backgroundColor: const Color(0xFF2575FC),
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
}
