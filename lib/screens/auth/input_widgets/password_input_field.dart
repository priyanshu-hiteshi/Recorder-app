import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordInputField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        // if (value == null || value.isEmpty) {
        //   return "Password Can't be empty";
        // } else if (value.length < 8) {
        //   return "Password must be 8 char long";
        // }
        // return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF2575FC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
