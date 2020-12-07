import 'dart:async';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_Screen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  static const id = "splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  String _testValue;
   bool isLogin= false;


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;_testValue = sharedPreferences.getString("login_response");
      if (_testValue == null)
        setState(() {
          isLogin = true;
        });

    });
   countDownTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage("images/logo.png"),width: 140,height: 140,),
      ),
    );
  }
  countDownTime() async {
    return Timer(
      Duration(seconds: 2),
          () async {
        if(isLogin)
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        else
          Navigator.pushReplacementNamed(context, HomeScreen.id);
      },
    );
  }
}
