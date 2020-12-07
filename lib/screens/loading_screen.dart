
import 'package:find_construction_new/models/house_main_models.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
class LoadingScreen extends StatefulWidget {
  static const id = "loading_screen";
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading=true;
  HouseMainModel _houseMainModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getLocation();

  }

  Future<HouseMainModel> getHomeLatLng(String lat, String lng) async {
    final String apiUrl = "https://construction.bazaaaar.com/latelong.php";
    final response = await http.post(apiUrl, body: {"lat": lat, "long": lng});
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("----------------------loading response ${response.body}----------------------------");
      setState(() {
        _houseMainModel= houseMainModelFromJson(responseString);
        isLoading= false;
      });
      return houseMainModelFromJson(responseString);
    } else {
      setState(() {
        isLoading=false;
      });
      return null;
    }
  }
  saveValue(double lat,double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location_lan', lat.toString());
    prefs.setString('location_lng', lng.toString());
  }
  void getLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    saveValue(position.latitude,position.longitude);
   getHomeLatLng(position.latitude.toString(),position.longitude.toString());

    print("-------------loading response ${_houseMainModel.response}-----------------------");


   /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return DetailScreen( houseMainModel: _houseMainModel  ,
     lat: position.latitude,lng: position.longitude,);}));*/

  }
  @override
  Widget build(BuildContext context) {
    return  isLoading? Container(
      color: Colors.white,
      child: Center(
        child:SpinKitThreeBounce(
          color:kBlueText,
          size: 50.0,
        ),
      ),
    ):  Scaffold(
      backgroundColor: Colors.white,
      body: Center(



      ),
    );
  }
}
