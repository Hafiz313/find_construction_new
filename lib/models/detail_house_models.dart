// To parse this JSON data, do
//
//     final detailHouseModel = detailHouseModelFromJson(jsonString);

import 'dart:convert';

DetailHouseModel detailHouseModelFromJson(String str) => DetailHouseModel.fromJson(json.decode(str));

String detailHouseModelToJson(DetailHouseModel data) => json.encode(data.toJson());

class DetailHouseModel {
  DetailHouseModel({
    this.message,
    this.response,
    this.status,
  });

  String message;
  Response response;
  bool status;

  factory DetailHouseModel.fromJson(Map<String, dynamic> json) => DetailHouseModel(
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
    this.name,
    this.mainIcon,
    this.icon,
    this.phone,
    this.email,
    this.bedroom,
    this.washroom,
    this.kitchen,
    this.area,
    this.location,
    this.shortDetail,
    this.latitude,
    this.longtitude,
    this.video,
    this.ischeck,
  });

  String id;
  String name;
  String mainIcon;
  List<String> icon;
  String phone;
  String email;
  String bedroom;
  String washroom;
  String kitchen;
  String area;
  String location;
  String shortDetail;
  String latitude;
  String longtitude;
  List<String> video;
  bool ischeck;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"],
    name: json["name"],
    mainIcon: json["main_icon"],
    icon: List<String>.from(json["icon"].map((x) => x)),
    phone: json["phone"],
    email: json["email"],
    bedroom: json["bedroom"],
    washroom: json["washroom"],
    kitchen: json["kitchen"],
    area: json["area"],
    location: json["location"],
    shortDetail: json["short_detail"],
    latitude: json["latitude"],
    longtitude: json["longtitude"],
    video: List<String>.from(json["video"].map((x) => x)),
    ischeck: json["ischeck"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "main_icon": mainIcon,
    "icon": List<dynamic>.from(icon.map((x) => x)),
    "phone": phone,
    "email": email,
    "bedroom": bedroom,
    "washroom": washroom,
    "kitchen": kitchen,
    "area": area,
    "location": location,
    "short_detail": shortDetail,
    "latitude": latitude,
    "longtitude": longtitude,
    "video": List<dynamic>.from(video.map((x) => x)),
    "ischeck": ischeck,
  };
}
