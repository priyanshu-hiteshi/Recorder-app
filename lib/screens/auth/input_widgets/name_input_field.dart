import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController nameController;
  const NameInputField({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: nameController,
        keyboardType: TextInputType.name,
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return "Name can't be empty";
        //   }
        //   return null;
        // },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Name',
          prefixIcon: const Icon(Icons.person, color: Color(0xFF2575FC)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ));
  }
}
