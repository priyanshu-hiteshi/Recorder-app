// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatapp/models/messages_modal.dart';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  String senderId;
  String recipientId;
  String content;
  SenderInfo senderInfo;

  MessageModel({
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.senderInfo,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        senderId: json["sender_id"],
        recipientId: json["recipient_id"],
        content: json["content"],
        senderInfo: SenderInfo.fromJson(json["sender_info"]),
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "recipient_id": recipientId,
        "content": content,
        "sender_info": senderInfo.toJson(),
      };
}
