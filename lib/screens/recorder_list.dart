import 'package:chatapp/helper/local_point.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/recorder_provider.dart';
import 'player_screen.dart';

class RecorderListScreen extends StatelessWidget {
  const RecorderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recorderProvider = Provider.of<RecorderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   "Recordings",
        //   style: TextStyle(color: Colors.black),
        // ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white, // Set the background color to white
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
            // padding: const EdgeInsets.all(10),
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final rawData = recordings[index];

              if (!rawData.contains('|')) {
                return ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: const Text("Invalid recording data"),
                  subtitle: Text(rawData),
                );
              }

              final savedData = rawData.split('|');
              final title =
                  savedData.isNotEmpty ? savedData[0] : "Unknown Title";
              final filePath =
                  savedData.length > 1 ? savedData[1] : "Unknown File Path";

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2575FC),
                    child: Icon(Icons.audiotrack, color: Colors.white),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        _renameRecording(
                            context, recorderProvider, index, title);
                      } else if (value == 'delete') {
                        _deleteRecording(context, recorderProvider, index);
                      } else if (value == 'generate') {
                        _generateRecording(context, filePath);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Text(
                          'Rename',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete',
                            style: TextStyle(color: Colors.black)),
                      ),
                      const PopupMenuItem(
                        value: 'generate',
                        child: Text('Generate',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          filePath: filePath,
                          fileName: title,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _renameRecording(BuildContext context, RecorderProvider provider,
      int index, String currentName) {
    final TextEditingController renameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename Recording"),
        content: TextField(
          controller: renameController,
          decoration: const InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newName = renameController.text.trim();
              if (newName.isNotEmpty) {
                provider.getRecordings().then((recordings) {
                  final savedData = recordings[index].split('|');
                  savedData[0] = newName;
                  recordings[index] = savedData.join('|');
                  provider.saveRecordingWithTitle(
                      newName); // Save the renamed recording
                  Navigator.pop(context);
                });
              }
            },
            child: const Text("Rename"),
          ),
        ],
      ),
    );
  }

  void _deleteRecording(
      BuildContext context, RecorderProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Recording"),
        content: const Text("Are you sure you want to delete this recording?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.getRecordings().then((recordings) {
                recordings.removeAt(index);
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setStringList(LocalPoint.recordings, recordings);
                  Navigator.pop(context);
                  provider.notifyListeners();
                });
              });
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _generateRecording(BuildContext context, String filePath) {
    // Your logic for generating something from the recording
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Generated from $filePath"),
      ),
    );
  }
}
