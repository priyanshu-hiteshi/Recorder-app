import 'dart:async';
import 'package:flutter/material.dart';

class RecorderHome extends StatefulWidget {
  const RecorderHome({super.key});

  @override
  State<RecorderHome> createState() => _RecorderHomeState();
}

class _RecorderHomeState extends State<RecorderHome> {
  bool isRecording = false;
  String timerText = "00:00";
  Timer? _timer;
  int secondsElapsed = 0;

  // Method to start recording
  void startRecording() {
    setState(() {
      isRecording = true;
      secondsElapsed = 0;
      timerText = "00:00";
    });

    // Start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
        final minutes = (secondsElapsed ~/ 60).toString().padLeft(2, '0');
        final seconds = (secondsElapsed % 60).toString().padLeft(2, '0');
        timerText = "$minutes:$seconds";
      });
    });
  }

  // Method to stop recording
  void stopRecording() {
    setState(() {
      isRecording = false;
    });

    // Cancel timer
    _timer?.cancel();
  }

  // Method to save the recording
  void saveRecording() {
    // Here, you would implement the logic to save the audio file.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recording saved!")),
    );

    setState(() {
      timerText = "00:00";
    });
  }

  // Method to navigate to the recorder list screen
  void navigateToRecorderList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecorderListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Recorder'),
      //   backgroundColor: const Color(0xFF2575FC),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Timer display
          Center(
            child: Text(
              timerText,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Save button (visible only if not recording and elapsed time > 0)
          if (!isRecording && secondsElapsed > 0)
            ElevatedButton(
              onPressed: saveRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2575FC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Save Recording",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            GestureDetector(
              onTap: isRecording ? stopRecording : startRecording,
              child: CircleAvatar(
                backgroundColor: isRecording ? Colors.red : const Color(0xFF2575FC),
                radius: 30,
                child: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),

             // Recorder List Button
            ElevatedButton(
              onPressed: navigateToRecorderList,
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.grey[300],
                // foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              // child: const Text(
              //   "Recorder List",
              //   style: TextStyle(fontSize: 16),
              // ),
              child: Icon(Icons.list ,color: const Color.fromARGB(255, 103, 102, 102),size: 30,),
            
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// A placeholder screen for the Recorder List
class RecorderListScreen extends StatelessWidget {
  const RecorderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorder List'),
        backgroundColor: const Color(0xFF2575FC),
      ),
      body: const Center(
        child: Text(
          'No recordings available yet!',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
