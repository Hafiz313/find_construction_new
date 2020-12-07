// To parse this JSON data, do
//
//     final favoriteModel = favoriteModelFromJson(jsonString);

import 'dart:convert';

FavoriteModel favoriteModelFromJson(String str) => FavoriteModel.fromJson(json.decode(str));

String favoriteModelToJson(FavoriteModel data) => json.encode(data.toJson());

class FavoriteModel {
  FavoriteModel({
    this.message,
    this.response,
    this.status,
  });

  String message;
  List<Response> response;
  bool status;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    message: json["message"],
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "status": status,
  };
}

class Response {
  Response({
    this.id,
    this.name,
    this.mainIcon,
    this.icon,
    this.phone,
    this.email,
    this.bedroom,
    this.washroom,
    this.kitchen,
    this.location,
    this.shortDetail,
    this.latitude,
    this.longtitude,
    this.video,
  });

  String id;
  String name;
  String mainIcon;
  dynamic icon;
  String phone;
  String email;
  String bedroom;
  String washroom;
  String kitchen;
  String location;
  String shortDetail;
  String latitude;
  String longtitude;
  dynamic video;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"],
    name: json["name"],
    mainIcon: json["main_icon"],
    icon: json["icon"],
    phone: json["phone"],
    email: json["email"],
    bedroom: json["bedroom"],
    washroom: json["washroom"],
    kitchen: json["kitchen"],
    location: json["location"],
    shortDetail: json["short_detail"],
    latitude: json["latitude"],
    longtitude: json["longtitude"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "main_icon": mainIcon,
    "icon": icon,
    "phone": phone,
    "email": email,
    "bedroom": bedroom,
    "washroom": washroom,
    "kitchen": kitchen,
    "location": location,
    "short_detail": shortDetail,
    "latitude": latitude,
    "longtitude": longtitude,
    "video": video,
  };
}

