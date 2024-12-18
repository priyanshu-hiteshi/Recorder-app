import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailInputField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // if (value == null || value.isEmpty) {
          //   return "Email can't be empty";
          // }
          // return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Email',
          prefixIcon: const Icon(Icons.email, color: Color(0xFF2575FC)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ));
  }
}
