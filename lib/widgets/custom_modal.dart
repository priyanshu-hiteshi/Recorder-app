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
      title: const Text("Save Recording"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              hintText: "Enter a title for the recording",
            ),
          ),
        ],
      ),
      actions: [
        Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          TextButton(
            onPressed: onCancel,
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onSave,
            child: Icon(
              Icons.bookmark_add_outlined,
              color: Colors.black,
            ),
            // child: const Text(
            //   "Save",
            //   style: TextStyle(color: Colors.green),
            // ),
          ),
        ])
      ],
    );
  }
}
