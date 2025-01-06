import 'package:chatapp/models/generate_text_model.dart';
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
  // GenerateSummary?  generateSummary ; 
  


  @override
  void initState() {
    super.initState();
    final recorderProvider =
        Provider.of<RecorderProvider>(context, listen: false);
    recorderProvider.fetchRecordings();
  }

  void Loader() {}

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
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    if (selectedAudios.isNotEmpty) {
                      await recorderProvider
                          .deleteSelectedRecordings(selectedAudios);
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
                          recording: recording,
                          // generateSummary: ,
                          
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 13, 13, 14).withOpacity(0.3)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    border: isSelected
                        ? Border.all(
                            color: const Color.fromARGB(255, 116, 116, 117),
                            width: 2)
                        : null,
                  ),
                  child: ListTile(
                    leading:  CircleAvatar(
                      backgroundColor: Colors.grey.shade200.withOpacity(0.1),
                      // backgroundColor: Color.fromRGBO(248, 141, 141, 1)
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
                        ? PopupMenuTheme(
                            data: PopupMenuThemeData(
                              color: Colors.grey.shade200.withOpacity(
                                  0.1), // Background color with opacity
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              
                              textStyle: TextStyle(
                                color: Colors.white, // Text color for all items
                              ),
                            ),
                            child: PopupMenuButton<String>(
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
                              },

                              offset: const Offset(0, 0),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'Rename',
                                  child: Text('Rename',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      )),
                                ),
                                PopupMenuItem(
                                  value: 'Delete',
                                  child: Text('Delete',
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
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
