// To parse this JSON data, do
//
//     final getUser = getUserFromJson(jsonString);

import 'dart:convert';

List<GetUser> getUserFromJson(String str) => List<GetUser>.from(json.decode(str).map((x) => GetUser.fromJson(x)));

String getUserToJson(List<GetUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUser {
    final String? userId;
    final String? username;
    final String? email;

    GetUser({
        required this.userId,
        required this.username,
        required this.email,
    });

    factory GetUser.fromJson(Map<String, dynamic> json) => GetUser(
        userId: json["UserID"],
        username: json["Username"],
        email: json["Email"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Username": username,
        "Email": email,
    };
}
