import 'package:find_construction_new/screens/about_us_screen.dart';
import 'package:find_construction_new/screens/code_verification_screen.dart';
import 'package:find_construction_new/screens/conformed_password_screen.dart';
import 'package:find_construction_new/screens/demo_class.dart';
import 'package:find_construction_new/screens/detail_screen.dart';
import 'package:find_construction_new/screens/forget_screen.dart';
import 'package:find_construction_new/screens/help_center_screen.dart';
import 'package:find_construction_new/screens/home_Screen.dart';
import 'package:find_construction_new/screens/loading_screen.dart';
import 'package:find_construction_new/screens/login_screen.dart';
import 'package:find_construction_new/screens/profile_screen.dart';
import 'package:find_construction_new/screens/registration_screen.dart';
import 'package:find_construction_new/screens/favorite_house_screen.dart';
import 'package:find_construction_new/screens/search_house_screen.dart';
import 'package:find_construction_new/screens/splash_screen.dart';
import 'package:find_construction_new/screens/vedio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        LoginScreen.id :(context) => LoginScreen(),
        SplashScreen.id:(context) => SplashScreen(),
        RegistrationScreen.id :(context) => RegistrationScreen(),
        HomeScreen.id :(context) => HomeScreen(),
        DemoClass.id :(context) => DemoClass(),
        FavoriteHouseScreen.id :(context) => FavoriteHouseScreen(),
        SearchHouseScreen.id :(context) => SearchHouseScreen(),
        DetailScreen.id :(context) => DetailScreen(),
        ForgetScreen.id :(context) => ForgetScreen(),
        CodeVerificationScreen.id:(context) => CodeVerificationScreen(),
        ConfermedPasswordScreen.id:(context) => ConfermedPasswordScreen(),
        LoadingScreen.id :(context) => LoadingScreen(),
        ProfileScreen.id :(context) => ProfileScreen(),
        AboutUsScreen.id :(context) => AboutUsScreen(),
        HelpCenterScreen.id :(context) => HelpCenterScreen(),
        ChewieDemo.id :(context) => ChewieDemo(),
      },
    );
  }
}