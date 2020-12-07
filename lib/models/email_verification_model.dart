// To parse this JSON data, do
//
//     final emailVerificationModel = emailVerificationModelFromJson(jsonString);

import 'dart:convert';

EmailVerificationModel emailVerificationModelFromJson(String str) => EmailVerificationModel.fromJson(json.decode(str));

String emailVerificationModelToJson(EmailVerificationModel data) => json.encode(data.toJson());

class EmailVerificationModel {
  EmailVerificationModel({
    this.message,
    this.response,
    this.status,
  });

  String message;
  Response response;
  bool status;

  factory EmailVerificationModel.fromJson(Map<String, dynamic> json) => EmailVerificationModel(
    message: json["message"],
    response: Response.fromJson(json["response"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "response": response.toJson(),
    "status": status,
  };
}

class Response {
  Response({
    this.id,
    this.email,
  });

  String id;
  String email;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
  };
}
