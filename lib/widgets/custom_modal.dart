import 'package:flutter/material.dart';

class SaveRecordingModal extends StatelessWidget {
  final TextEditingController titleController;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const SaveRecordingModal({
    super.key,
    required this.titleController,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200
          .withOpacity(0.1), // Set the background color to dark gray
      title: const Text(
        "Save Recording",
        style: TextStyle(
            color:
                Colors.white), // White text for title to match dark background
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            style: const TextStyle(
                color: Colors.white), // White text in the input field
            decoration: const InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.white), // White label text
              hintText: "Enter a title for the recording",
              hintStyle:
                  TextStyle(color: Colors.white60), // Lighter gray hint text
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white), // White underline when focused
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel button with background color
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[900], // Red background color
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold), // White text on red background
              ),
            ),

            // Save button
            TextButton(
              onPressed: onSave,
              child: const Icon(
                Icons.bookmark_outline,
                color: Colors.white, // White icon to match dark background
              ),
            ),
          ],
        ),
      ],
    );
  }
}
