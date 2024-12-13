import 'dart:convert';

import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignupApiFunction {
  static Future<void> signup({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        final body = {
          "name": name,
          "email": email,
          "password": password,
          "socketId": "", // Include socketId if necessary
        };

        // Make API request
        final response = await ApiService.postRequest(
          endPoint: EndPoints.users,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print("Signup successful: $responseData");

          // Trigger the success callback
          onSuccess();
        } else {
          showError(context, "Signup failed. Please check your credentials.");
        }
      } else {
        showError(context, "Please fill in all the fields.");
      }
    }catch(e){
      print("something went wrong ${e}") ; 
    } 
    
  }
}
