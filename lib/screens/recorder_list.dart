import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/all_audios_model.dart';
import '../provider/recorder_provider.dart';
import 'player_screen.dart';
import '../widgets/rename_dialog_modal.dart';

class RecorderListScreen extends StatefulWidget {
  const RecorderListScreen({super.key});

  @override
  _RecorderListScreenState createState() => _RecorderListScreenState();
}

class _RecorderListScreenState extends State<RecorderListScreen> {
  List<int> selectedAudios = [];
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    final recorderProvider =
        Provider.of<RecorderProvider>(context, listen: false);
    recorderProvider.fetchRecordings();
  }

  void Loader() {
    
  }

  void toggleSelectionMode(bool enable) {
    setState(() {
      isSelectionMode = enable;
      if (!enable) selectedAudios.clear(); 
    });
  }

  void handleSelection(int audioId) {
    setState(() {
      if (selectedAudios.contains(audioId)) {
        selectedAudios.remove(audioId);
      } else {
        selectedAudios.add(audioId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recorderProvider = Provider.of<RecorderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isSelectionMode
              ? '${selectedAudios.length}    Selected'
              : 'Recordings',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold , fontSize:16 ),
        ),
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    if (selectedAudios.isNotEmpty) {
                      await recorderProvider.deleteSelectedRecordings(
                          selectedAudios);
                      toggleSelectionMode(false); // Exit selection mode
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  onPressed: () => toggleSelectionMode(false),
                ),
              ]
            : [],
      ),
      backgroundColor: Colors.black,
      body: Consumer<RecorderProvider>(
        builder: (context, recorderProvider, child) {
        if (recorderProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey[300],
            ),
          );
        }



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
              final isSelected = selectedAudios.contains(recording.id);

              return GestureDetector(
                onLongPress: () => toggleSelectionMode(true),
                onTap: () {
                  if (isSelectionMode) {
                    handleSelection(recording.id);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          filePath: recording.fileUrl,
                          fileName: recording.filename,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 13, 13, 14).withOpacity(0.3)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    border: isSelected
                        ? Border.all(color: const Color.fromARGB(255, 116, 116, 117), width: 2)
                        : null,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color.fromRGBO(248, 141, 141, 1),
                      child: Icon(Icons.audiotrack, color: Colors.white),
                    ),
                    title: Text(
                      recording.filename,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    trailing: !isSelectionMode
                        ? PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onSelected: (value) {
                              if (value == 'Rename') {
                                showRenameModal(
                                    context, recorderProvider, recording);
                              } else if (value == 'Delete') {
                                recorderProvider.deleteRecording(
                                    context, recording);
                              }

                               else if (value == 'Generate') {
                                recorderProvider.generateRecordingData(
                                    context, recording);
                              } else if (value == 'Show') {
                                recorderProvider.showSummary(
                                    context, recording);
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
                          )
                        : null,
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
