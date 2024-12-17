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
     this.recipientId,
    this.roomId,
    required this.senderInfo,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        id: int.tryParse(json["id"].toString()) ?? 0, // Safe parsing for id
        content: json["content"] ?? "",
        senderId: int.tryParse(json["sender_id"].toString()) ?? 0,
        recipientId: json["recipient_id"] != null
            ? int.tryParse(json["recipient_id"].toString())
            : null,
        roomId: json["room_id"] != null
            ? int.tryParse(json["room_id"].toString())
            : null,
        senderInfo: SenderInfo.fromJson(json["sender_info"] ?? {}),
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
  int? id;
  String ?name;
  String? email;

  SenderInfo({
     this.id,
   this.name,
    this.email,
  });

  factory SenderInfo.fromJson(Map<String, dynamic> json) => SenderInfo(
        id: int.tryParse(json["id"].toString()) ?? 0, // Safe parsing for id
        name: json["name"] ?? "",
        email: json["email"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
