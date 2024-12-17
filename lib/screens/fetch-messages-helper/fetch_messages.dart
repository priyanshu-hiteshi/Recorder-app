import 'dart:convert';
import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchMessages {
  /// Fetch messages between the sender and recipient.
  ///
  ///
  static Future<List<dynamic>> fetchMessage({
    // required int senderId,
    required int recipientId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(LocalPoint.authToken);

    final loguserId = prefs.getInt(LocalPoint.LoguserId);

    if (token == null) {
      throw Exception("No token found. Please login.");
    }

    try {
      // Build the query parameters dynamically
      final queryParameters = '?sender_id=$loguserId&recipient_id=$recipientId';

      // Use ApiService.getRequest
      final response = await ApiService.getRequest(
        endPoint: EndPoints.messages + queryParameters, // Add query params
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Parse the response and return the message list
      print(response.body);
      return json.decode(response.body);
    } catch (e) {
      throw Exception("Error during API request: $e");
    }
  }
}
