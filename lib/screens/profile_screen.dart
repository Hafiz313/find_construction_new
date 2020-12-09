import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_construction_new/models/uploadpic.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:find_construction_new/weight/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
class ProfileScreen extends StatefulWidget {
  static const id = "profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  String strName="", strMail="", strAddress="", strPhoneNo="",imageUrl="",userId="";
  File imageFile;
  bool isUrl= false;
  bool uploadPhoto=false;
  UploadPicture _uploadPicture;

 /* Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
       print("-----------$imageFile---------------");
       _cropImage(imageFile);
      });
    }
  }*/

  @override
  void initState() {
    super.initState();
    setState(() {

    });
    read();
  }

  Future<void> read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      strName =
          json.decode(prefs.getString("login_response"))["response"][0]["name"]?? "";
      userId=
          json.decode(prefs.getString("login_response"))["response"][0]["id"]?? "";
      imageUrl =
          json.decode(prefs.getString("login_response"))["response"][0]["img"]?? "";

      if(imageUrl==null || imageUrl.isEmpty || imageUrl==""){

        setState(() {
          print("----------------no ok url--------------");
          isUrl=true;
        });
      }


      strMail = json.decode(prefs.getString("login_response"))["response"][0]
          ["email"] ?? "";
      strAddress = json.decode(prefs.getString("login_response"))["response"][0]
          ["address"] ?? "";
      strPhoneNo = json.decode(prefs.getString("login_response"))["response"][0]
          ["phone"] ?? "";
    });
    print(
        "-----------------------login data in profile ${json.decode(prefs.getString("login_response"))["response"][0]["name"]}-------------------");
    print("-----------name: $strName emaill :$strMail, address: $strAddress phone $strPhoneNo imageUrl: $imageUrl --------");
    return json.decode(prefs.getString("login_response"));
  }
  Future<Null> _cropImage(  ) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);


    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kBlueText,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    print("----------cropper image: $croppedFile------------");
    if (croppedFile != null) {

      setState(() {
        uploadPhoto=true;
      });

      try {
        final UploadPicture uploadPicture = await _uploadImage(croppedFile);
        setState(() {
          _uploadPicture=uploadPicture;
        });

        if(_uploadPicture != null)
        {
          save(_uploadPicture);
          if(_uploadPicture.status)
          {
            setState(() {
              uploadPhoto=false;
              imageFile = croppedFile;
              imageUrl=uploadPicture.response.img;
            });

          }
          else
          {
            setState(() {
              uploadPhoto=false;
            });

          }
        }


      } catch (e) {
        print(e);
        return null;
      }

      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueText,
          title: Text("Profile"),
        ),
        drawer: HomeDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: (){
                 _cropImage();
                  print("--------------Select Image----------------");

                },
                child: !uploadPhoto?Container(
                  height: 180.0,
                  width: 180.0,
                  child:Center(
                    child: CachedNetworkImage(
                        placeholder: (context,url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                            ),
                          ),
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(100.0))
                          ),
                        ),
                        errorWidget: (context,url,error) => Material(
                          child: Image.asset("images/img_not_available.jpeg",
                            height: 180,
                            width: 180,
                            fit: BoxFit.fitWidth,),
                          borderRadius: BorderRadius.all(Radius.circular(100.0)),
                          clipBehavior: Clip.hardEdge,

                        ),
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        height: 180,
                        width: 180,
                        fit: BoxFit.fitWidth

                    ),
                  ),
                ):Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                )
              ),



              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Name",
                        style: TextStyle(
                          color: kBlueText,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                          "$strName",

                        style: TextStyle(
                          color: kGry,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Divider(color: kGryBG, thickness: 1)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Gmail ",
                        style: TextStyle(
                          color: kBlueText,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                         "$strMail",
                        style: TextStyle(
                          color: kGry,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Divider(color: kGryBG, thickness: 1)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Address ",
                        style: TextStyle(
                          color: kBlueText,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                          "$strAddress",

                        style: TextStyle(
                          color: kGry,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Divider(color: kGryBG, thickness: 1)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Phone Number ",
                        style: TextStyle(
                          color: kBlueText,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "$strPhoneNo",

                        style: TextStyle(
                          color: kGry,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Divider(color: kGryBG, thickness: 1)
                  ],
                ),
              ),
            ],
          ),
        ),

        /*Container(
          height: 300,
          width: double.infinity,
          color: kBlueText,
          child: Column(
            children: [

              Stack(

                children: [
                  Container(
                    height: 100,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/home_bg.png'),
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                      ),
                    ),
                  ),
                  OverflowBox(
                    minWidth: 0.0,
                    maxWidth: 10.0,
                    minHeight: 0.0,
                    maxHeight: 10.0,
                    child: Container(
                      height: 20,
                      width: 20,
                      color: Colors.grey,
                    ),
                  )
                ],
              )

            ],
          ),
        ),*/
      ),
    );
  }


  Future<UploadPicture> _uploadImage(File image) async {

    String id= userId;
    String apiUrl="https://construction.bazaaaar.com/update-Image.php";

    final file = await http.MultipartFile.fromPath('image', image.path);


// Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));
    imageUploadRequest.fields['id'] = id;
    imageUploadRequest.files.add(file);


    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        setState(() {
          uploadPhoto=false;
        });

        Fluttertoast.showToast(msg: "Cannot Connect with server");

        return null;
      }
      else
      {
        final String responseString=response.body;
        log(response.body);
        setState(() {
          uploadPhoto=false;
        });
        return uploadPictureModelFromJson(responseString);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  Future<String> getStringValue(String key) async {
// get shared preference instance.
    SharedPreferences prefs = await SharedPreferences.getInstance();
// Set the key ('isLoggenIn') with a value (true/false) here.
    String value = prefs.getString(key);
    return value;
  }
  save(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_response", json.encode(value));
  }
}


