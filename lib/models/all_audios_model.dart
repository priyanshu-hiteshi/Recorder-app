// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
    bool success;
    String message;
    List<AllAudio> allAudios;

    MessageModel({
        required this.success,
        required this.message,
        required this.allAudios,
    });

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        success: json["success"],
        message: json["message"],
        allAudios: List<AllAudio>.from(json["allAudios"].map((x) => AllAudio.fromJson(x))),
    );

  

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "allAudios": List<dynamic>.from(allAudios.map((x) => x.toJson())),
    };
}

class AllAudio {
    int id;
    String filename;
    String fileUrl;
    String summariesText;
    int? speakers;
    DateTime createdAt;
    DateTime updatedAt;

    AllAudio({
        required this.id,
        required this.filename,
        required this.fileUrl,
        required this.summariesText,
        required this.speakers,
        required this.createdAt,
        required this.updatedAt,
    });

    factory AllAudio.fromJson(Map<String, dynamic> json) => AllAudio(
        id: json["id"],
        filename: json["filename"],
        fileUrl: json["fileUrl"],
        summariesText: json["summariesText"],
        speakers: json["speakers"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "fileUrl": fileUrl,
        "summariesText": summariesText,
        "speakers": speakers,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
