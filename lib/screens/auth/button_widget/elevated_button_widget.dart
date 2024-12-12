import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final void Function() onPressed;
  final String buttonName;
  final Color backgroundColor;

  const ElevatedButtonWidget({
    super.key,
    required this.onPressed,
    required this.buttonName,
    this.backgroundColor = const Color(0xFF2575FC),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: const Color.fromARGB(255, 244, 245, 246),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Text(
        buttonName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
