//  showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             'Rename Recording',
//             style: GoogleFonts.poppins(
//                 color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               labelText: 'New Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 'Cancel',
//                 style: GoogleFonts.poppins(
//                     color: Colors.red, fontWeight: FontWeight.w400),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 String newName = controller.text.trim();

//                 if (newName.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Name cannot be empty')),
//                   );
//                   return;
//                 }

//                 Navigator.pop(context); // Close the dialog

//                 try {
//                   // API endpoint
//                   final String url =
//                       '${AppConfig.baseUrl}${EndPoints.renameFile}${recording.id}';

//                   // Request payload
//                   final Map<String, String> body = {
//                     "newName": newName,
//                   };

//                   // API call
//                   final response = await http.put(
//                     Uri.parse(url),
//                     headers: {
//                       "Content-Type": "application/json",
//                     },
//                     body: jsonEncode(body),
//                   );

//                   if (response.statusCode == 200) {
//                     // Update local filename and notify listeners
//                     recording.filename = newName;
//                     notifyListeners();

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Recording renamed successfully!')),
//                     );

//                     await fetchRecordings() ; 
//                   } else {
//                     // Handle server errors
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             'Failed to rename the recording. Status code: ${response.statusCode}'),
//                       ),
//                     );
//                   }
//                 } catch (e) {
//                   // Handle connection errors
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('An error occurred: ${e.toString()}'),
//                     ),
//                   );
//                 }
//               },
//               child: Text(
//                 'Rename',
//                 style: GoogleFonts.poppins(
//                     color: Colors.black, fontWeight: FontWeight.w400),
//               ),
//             ),
//           ],
//         );
//       },
//     );