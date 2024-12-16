import 'dart:convert';

List<Messages> welcomeFromJson(String str) => List<Messages>.from(json.decode(str).map((x) => Messages.fromJson(x)));

String welcomeToJson(List<Messages> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Messages {
    int id;
    String content;
    int senderId;
    int? recipientId;
    int? roomId;
    SenderInfo senderInfo;

    Messages({
        required this.id,
        required this.content,
        required this.senderId,
        required this.recipientId,
        required this.roomId,
        required this.senderInfo,
    });

    factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        id: json["id"],
        content: json["content"],
        senderId: json["sender_id"],
        recipientId: json["recipient_id"],
        roomId: json["room_id"],
        senderInfo: SenderInfo.fromJson(json["sender_info"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "sender_id": senderId,
        "recipient_id": recipientId,
        "room_id": roomId,
        "sender_info": senderInfo.toJson(),
    };
}

class SenderInfo {
    int id;
    String name;
    String email;

    SenderInfo({
        required this.id,
        required this.name,
        required this.email,
    });

    factory SenderInfo.fromJson(Map<String, dynamic> json) => SenderInfo(
        id: json["id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
    };
}
