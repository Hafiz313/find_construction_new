import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_construction_new/screens/about_us_screen.dart';
import 'package:find_construction_new/screens/demo_class.dart';

import 'package:find_construction_new/screens/help_center_screen.dart';
import 'package:find_construction_new/screens/home_Screen.dart';
import 'package:find_construction_new/screens/login_screen.dart';
import 'package:find_construction_new/screens/profile_screen.dart';
import 'package:find_construction_new/screens/favorite_house_screen.dart';
import 'package:find_construction_new/screens/vedio_player.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String strName="", strMail="", strAddress="", strPhoneNo="",imageUrl="",userId="";
  bool isUrl=false;
  _textMe() async {
    // Android
    const uri = 'sms:?body=here%20link:www.google.com';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:?body=here%20link:www.google.com';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  @override
  void initState() {
    super.initState();
    read();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                          placeholder: (context,url) => Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              ),
                            ),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(80.0))
                            ),
                          ),
                          errorWidget: (context,url,error) => Material(
                            child: Image.asset("images/img_not_available.jpeg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.fitWidth,),
                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                            clipBehavior: Clip.hardEdge,

                          ),
                          imageUrl: imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          height: 80,
                          width: 80,
                          fit: BoxFit.fitWidth
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$strName',
                      style: TextStyle(fontSize: 20, color: kBlueText),
                    ),
                  ],
                )),
            decoration: BoxDecoration(),
          ),
          ListTile(
            title: Text('Home', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.home,
              color: kBlueText,

            ),
            onTap: () {

              Navigator.pushNamed(context, HomeScreen.id);
            },
          ),
          ListTile(
            title: Text('Profile', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.userCircle,
              color: kBlueText,

            ),
            onTap: () {

              Navigator.pushNamed(context, ProfileScreen.id);
            },
          ),
          ListTile(
            title: Text('Favorite', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.solidHeart,
              color: kBlueText,
            ),
            onTap: () {
              Navigator.pushNamed(context, FavoriteHouseScreen.id);
            },
          ),

          ListTile(
            title: Text('About us', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.exclamationCircle,
              color: kBlueText,
            ),
            onTap: () {
             Navigator.pushNamed(context, AboutUsScreen.id);
            },
          ),
          ListTile(
            title: Text('Help center', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.questionCircle,
              color: kBlueText,

            ),
            onTap: () {
             Navigator.pushNamed(context, HelpCenterScreen.id);

            },
          ),
          ListTile(
            title: Text('Tell a Friend', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.shareAlt,
              color: kBlueText,

            ),
            onTap: () {

              share(context);
            },
          ),
         /* ListTile(
            title: Text('test', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.shareAlt,
              color: kBlueText,

            ),
            onTap: () {

             Navigator.pushNamed(context, DemoClass.id);
            },
          ),*/
          ListTile(
            title: Text('Logout', style: TextStyle(fontSize: 15),),
            leading: Icon(FontAwesomeIcons.signOutAlt,
              color: kBlueText,

            ),
            onTap: () async {

              final pref = await SharedPreferences.getInstance();
              await pref.clear();
              _googleSignIn.signOut();
             Navigator.pushReplacementNamed(context, LoginScreen.id);


            },
          ),

        ],
      ),
    );
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

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = "link here : www.google.com";
    print("---------$text---------");
    Share.share(text,
        subject: 'Read Article',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}


