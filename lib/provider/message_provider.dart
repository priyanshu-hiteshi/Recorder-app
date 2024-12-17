import 'package:chatapp/models/messages_modal.dart';
import 'package:chatapp/screens/fetch-messages-helper/fetch_messages.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  List<Messages> messages = [];
  bool isLoading = false;
  Future<void> fetchMessages({required int userId}) async {
    try {
      final response = await FetchMessages.fetchMessage(
        recipientId: userId, // Replace with the recipient's ID dynamically
      );

      messages = response.map((e) => Messages.fromJson(e)).toList();
      isLoading = false;
    } catch (e) {
      isLoading = false;

      print("Error fetching messages: $e");
    }
    notifyListeners();
  }
}
