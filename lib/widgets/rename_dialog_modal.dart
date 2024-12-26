

import 'package:chatapp/provider/recorder_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/all_audios_model.dart';  


void showRenameModal(BuildContext context, RecorderProvider provider, AllAudio recording) {
  TextEditingController controller = TextEditingController(text: recording.filename);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Rename Recording',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the modal
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                  color: Colors.red, fontWeight: FontWeight.w400),
            ),
          ),
          TextButton(
            onPressed: () async {
              String newName = controller.text.trim();

              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
                );
                return;
              }

              Navigator.pop(context); 

              
              bool success = await provider.renameAudioFile(recording.id , newName);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recording renamed successfully!')),
                );
                // Update the local model if needed
                recording.filename = newName;
                provider.notifyListeners();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to rename the recording')),
                );
              }
            },
            child: Text(
              'Rename',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      );
    },
  );
}
