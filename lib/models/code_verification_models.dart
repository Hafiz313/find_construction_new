// To parse this JSON data, do
//
//     final codeVerificationModel = codeVerificationModelFromJson(jsonString);

import 'dart:convert';

CodeVerificationModel codeVerificationModelFromJson(String str) => CodeVerificationModel.fromJson(json.decode(str));

String codeVerificationModelToJson(CodeVerificationModel data) => json.encode(data.toJson());

class CodeVerificationModel {
  CodeVerificationModel({
    this.message,
    this.response,
    this.status,
  });

  String message;
  List<dynamic> response;
  bool status;

  factory CodeVerificationModel.fromJson(Map<String, dynamic> json) => CodeVerificationModel(
    message: json["message"],
    response: List<dynamic>.from(json["response"].map((x) => x)),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x)),
    "status": status,
  };
}
