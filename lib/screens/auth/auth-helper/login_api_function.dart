import 'dart:convert';

import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApiFunction {
  static Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    try {
      final trimmedEmail = email.trim().toLowerCase();
      final body = {
        "email": trimmedEmail,
        "password": password,
        "socketId": "",
      };

      final response = await ApiService.postRequest(
        endPoint: EndPoints.login,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(LocalPoint.authToken, token);

          onSuccess();
        } else {
          showError(context, "Token not received.");
        }
      } else if (response.statusCode == 404) {
        showError(context, "Email not found. Please sign up.");
      } else if (response.statusCode == 401) {
        showError(context, "Invalid credentials. Please try again.");
      } else {
        showError(context, "An error occurred. Please try again.");
      }
    } catch (e) {
      showError(context, "An error occurred: $e");
      print(e) ; 
    }
  }
}
