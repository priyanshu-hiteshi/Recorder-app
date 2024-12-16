// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<UserModel> welcomeFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String welcomeToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
    int id;
    String name;
    String? socketId;
    String email;
    String password;

    UserModel({
        required this.id,
        required this.name,
        required this.socketId,
        required this.email,
        required this.password,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        socketId: json["socket_id"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "socket_id": socketId,
        "email": email,
        "password": password,
    };
}
