import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/recorder_provider.dart';
import 'player_screen.dart';

class RecorderListScreen extends StatelessWidget {
  const RecorderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recorderProvider = Provider.of<RecorderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recordings"),
        backgroundColor: const Color(0xFF2575FC),
      ),
      body: FutureBuilder<List<String>>(
        future: recorderProvider.getRecordings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No recordings found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final recordings = snapshot.data!;
          return ListView.builder(
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final filePath = recordings[index];
              final fileName = filePath.split('/').last;

              return ListTile(
                leading: const Icon(Icons.audiotrack, color: Color(0xFF2575FC)),
                title: Text(fileName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        filePath: filePath,
                        fileName: fileName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
