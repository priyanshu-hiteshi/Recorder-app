import 'dart:convert';
import 'dart:developer';

import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/models/post_message_model.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMessagesService {
  static Future<Map<String, dynamic>> sendMessage({
    required MessageModel messageModel,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(LocalPoint.authToken);

      // final loguserId = prefs.getInt(LocalPoint.LoguserId);

      final Map<String, dynamic> body = messageModel.toJson();
      log(jsonEncode(body));

      final response = await ApiService.postRequest(
          endPoint: EndPoints.messages,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: body);

      final responseData = jsonDecode(response.body);
      print(responseData['data']);
      return responseData['data'];
    } catch (e) {
      print("Error in sendMessage:$e");
      throw Exception("Error while sending message : $e");
    }
  }
}
