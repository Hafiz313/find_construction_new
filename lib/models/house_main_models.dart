// To parse this JSON data, do
//
//     final houseMainModel = houseMainModelFromJson(jsonString);

import 'dart:convert';

HouseMainModel houseMainModelFromJson(String str) => HouseMainModel.fromJson(json.decode(str));

String houseMainModelToJson(HouseMainModel data) => json.encode(data.toJson());

class HouseMainModel {
  HouseMainModel({
    this.message,
    this.response,
    this.status,
  });

  String message;
  List<Response> response;
  bool status;

  factory HouseMainModel.fromJson(Map<String, dynamic> json) => HouseMainModel(
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
    this.icon,
    this.mainIcon,
    this.phone,
    this.email,
    this.bedroom,
    this.washroom,
    this.kitchen,
    this.location,
    this.shortDetail,
    this.area,
    this.latitude,
    this.longtitude,
    this.video,
    this.ischeck,
  });

  String id;
  String name;
  List<String> icon;
  String mainIcon;
  String phone;
  String email;
  String bedroom;
  String washroom;
  String kitchen;
  String location;
  String shortDetail;
  String area;
  String latitude;
  String longtitude;
  List<String> video;
  bool ischeck;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"],
    name: json["name"],
    icon: List<String>.from(json["icon"].map((x) => x)),
    mainIcon: json["main_icon"],
    phone: json["phone"],
    email: json["email"],
    bedroom: json["bedroom"],
    washroom: json["washroom"],
    kitchen: json["kitchen"],
    location: json["location"],
    shortDetail: json["short_detail"],
    area: json["area"],
    latitude: json["latitude"],
    longtitude: json["longtitude"],
    video: List<String>.from(json["video"].map((x) => x)),
    ischeck: json["ischeck"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": List<dynamic>.from(icon.map((x) => x)),
    "main_icon": mainIcon,
    "phone": phone,
    "email": email,
    "bedroom": bedroom,
    "washroom": washroom,
    "kitchen": kitchen,
    "location": location,
    "short_detail": shortDetail,
    "area": area,
    "latitude": latitude,
    "longtitude": longtitude,
    "video": List<dynamic>.from(video.map((x) => x)),
    "ischeck": ischeck,
  };
}
