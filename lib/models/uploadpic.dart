import 'dart:convert';

UploadPicture uploadPictureModelFromJson(String str) => UploadPicture.fromJson(json.decode(str));

String uploadPictureModelToJson(UploadPicture data) => json.encode(data.toJson());

class UploadPicture {
  String message;
  Response response;
  bool status;

  UploadPicture({this.message, this.response, this.status});

  UploadPicture.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Response {
  String id;
  String name;
  String phone;
  String address;
  String email;
  String img;

  Response(
      {this.id, this.name, this.phone, this.address, this.email, this.img});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    email = json['email'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['img'] = this.img;
    return data;
  }
}