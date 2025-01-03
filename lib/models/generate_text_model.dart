// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

GenerateTextMessage messageModelFromJson(String str) =>
    GenerateTextMessage.fromJson(json.decode(str));

String messageModelToJson(GenerateTextMessage data) =>
    json.encode(data.toJson());

class GenerateTextMessage {
  bool success;
  String message;
  GenerateSummary generateSummary;

  GenerateTextMessage({
    required this.success,
    required this.message,
    required this.generateSummary,
  });

  factory GenerateTextMessage.fromJson(Map<String, dynamic> json) =>
      GenerateTextMessage(
        success: json["success"],
        message: json["message"],
        generateSummary: GenerateSummary.fromJson(
            json["generateSummary"] ?? json["updatedFile"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "generateSummary": generateSummary.toJson(),
      };
}

class GenerateSummary {
  int id;
  String filename;
  String fileUrl;
  String summariesText;
  String transcript ; 
  int speakers;
  DateTime createdAt;
  DateTime updatedAt;

  GenerateSummary({
    required this.id,
    required this.filename,
    required this.fileUrl,
    required this.summariesText,
    required this.transcript , 
    required this.speakers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GenerateSummary.fromJson(Map<String, dynamic> json) =>
      GenerateSummary(
        id: json["id"],
        filename: json["filename"],
        fileUrl: json["fileUrl"],
        summariesText: json["summariesText"],
        transcript : json["transcript"] , 
        speakers: json["speakers"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "fileUrl": fileUrl,
        "summariesText": summariesText,
        "transcript" : transcript , 
        "speakers": speakers,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
