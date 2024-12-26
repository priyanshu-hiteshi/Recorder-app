import 'package:flutter/material.dart';

void showError(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showSnackBar(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showSuccessSnackBar(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
