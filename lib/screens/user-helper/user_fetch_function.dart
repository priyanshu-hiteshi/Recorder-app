import 'dart:convert';
import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserFetchFunction {
  static Future<List<dynamic>> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(LocalPoint.authToken); // Retrieve the token

    if (token == null) {
      throw Exception("No token found. Please login.");
    }

    try {
      // Use ApiService.getRequest
      final response = await ApiService.getRequest(
        endPoint: EndPoints.users,
        headers: {
          'Authorization': 'Bearer $token', // Pass the token as a Bearer token
        },
      );

      // Parse the response and return the user list
      return json.decode(response.body);
    } catch (e) {
      throw Exception("Error during API request: $e");
    }
  }
}
