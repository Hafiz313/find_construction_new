import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/screens/favorite_house_screen.dart';
import 'package:find_construction_new/screens/search_house_screen.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:find_construction_new/weight/home_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:find_construction_new/models/house_main_models.dart' as house;
import 'package:find_construction_new/models/house_main_models.dart'
    as newHouse;
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBestHouseLoading = true;
  bool isNewHouseLoading = true;
  bool isMapLoading = true;
  house.HouseMainModel _houseMainModel;
  newHouse.HouseMainModel _houseNewHouse;
  bool isFavoriteCheck = false;
  Position position;
  String userId;
  Set<Marker> _markers;
  bool isInterNetCheck = true;

  // ignore: non_constant_identifier_names
  Future<void> InternetCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _markers = Set.from([]);
      readID();
      getLocation();
      getNewHouse();
      setState(() {
        isInterNetCheck = false;
        print("availabel");
      });
    } else {
      setState(() {
        isInterNetCheck = true;
        print("ont availabel");
      });
    }
  }

  // _markers.add(Marker(markerId: MarkerId('SomeId') position: LatLng(38.123,35.123),infoWindow: InfoWindow(title: 'The title of the marker'));
  Future<void> read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = json.decode(prefs.getString("login_response"))["response"]
              ["id"] ??
          "";
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<house.HouseMainModel> getHomeLatLng(
      String lat, String lng, String id) async {
    final String apiUrl = "https://construction.bazaaaar.com/latelong.php";
    final response =
        await http.post(apiUrl, body: {"lat": lat, "long": lng, "id": id});
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("-----------Best House  : ${response.body}--------------------");

      return house.houseMainModelFromJson(responseString);
    } else {
      setState(() {
        isBestHouseLoading = false;
      });
      return null;
    }
  }

  Future<house.HouseMainModel> setFavoriteIHouse(
      String userId, String catId, String addOrUf, BuildContext context) async {
    final String apiUrl = "https://construction.bazaaaar.com/favorite.php";
    final response = await http
        .post(apiUrl, body: {"uid": userId, "cid": catId, addOrUf: ""});
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(
          "----------------------setFavoriteIHouse ${house.houseMainModelFromJson(responseString).message}----------------------------");

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, HomeScreen.id);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(house.houseMainModelFromJson(responseString).message)));
      return house.houseMainModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<newHouse.HouseMainModel> getNewHouse() async {
    final String apiUrl = "https://construction.bazaaaar.com/newArrival.php";
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(
          "-----------New House Response : ${response.body}--------------------");
      setState(() {
        _houseNewHouse = house.houseMainModelFromJson(responseString);
        isNewHouseLoading = false;
      });

      return house.houseMainModelFromJson(responseString);
    } else {
      setState(() {
        isNewHouseLoading = false;
      });
      return null;
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 10), child: Text(" Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  saveValue(double lat, double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location_lan', lat.toString());
    prefs.setString('location_lng', lng.toString());
  }

  void getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("-------------------lat: ${position.latitude} and lng: ${position.longitude}------------");

    saveValue(position.latitude, position.longitude);
    setState(() {
      isMapLoading = false;
      _markers.add(
        Marker(
            // ignore: deprecated_member_use
            icon: BitmapDescriptor.fromAsset("images/home_marker.png"),
            markerId: MarkerId('SomeId'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'The title of the marker')),
      );
    });
    await LatLngApiHit();
  }

  // ignore: non_constant_identifier_names
  Future LatLngApiHit() async {
   // final house.HouseMainModel houseMainModel = await getHomeLatLng("31.4888", "74.3686", userId);
    print(
        "-------------------lat: ${position.latitude} and lng: ${position.longitude} and id:$userId------------");
     final house.HouseMainModel houseMainModel= await getHomeLatLng(position.latitude.toString(),position.longitude.toString(),userId);
    setState(() {
      _houseMainModel = houseMainModel;
    });
    if (_houseMainModel != null) {
      if (_houseMainModel.status) {
        setState(() {
          isBestHouseLoading = false;
        });

        for (int i = 0; i < houseMainModel.response.length; i++) {
          setState(() {
            _markers.add(Marker(
                // ignore: deprecated_member_use
                //   icon: BitmapDescriptor.fromAsset("images/home_marker.png"),
                markerId: MarkerId(i.toString()),
                infoWindow: InfoWindow(title: houseMainModel.response[i].name),
                position: LatLng(
                    double.parse(houseMainModel.response[i].latitude),
                    double.parse(houseMainModel.response[i].longtitude))));
          });
        }
      } else {
        setState(() {
          isBestHouseLoading = false;
        });
      }
    }
  }

  Future<void> readID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = json.decode(prefs.getString("login_response"))["response"][0]
              ["id"] ??
          "";

      print("----------share $userId----------");
    });
  }

  @override
  void initState() {
    super.initState();
    InternetCheck();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: true,
              title: Text("Find Construction Home"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search,)
                  ,
                  onPressed: () {
                    Navigator.pushNamed(context, SearchHouseScreen.id);
                  },
                ),
              ]),
          drawer: HomeDrawer(),
          body: isInterNetCheck
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mobile is not Connected to Internet",
                          style: TextStyle(color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, HomeScreen.id);
                              },
                              child: Text(
                                "Retry",
                                style: TextStyle(color: kBlueText),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              : Builder(
                  builder: (context) => Center(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 150,
                                  child: Center(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: isMapLoading
                                          ? Container(
                                              color: Colors.white,
                                              child: Center(
                                                child: SpinKitDualRing(
                                                  color: kBlueText,
                                                  size: 50.0,
                                                ),
                                              ),
                                            )
                                          : GoogleMap(
                                              tiltGesturesEnabled: false,
                                              mapType: MapType.normal,
                                              scrollGesturesEnabled: true,
                                              zoomGesturesEnabled: true,
                                              gestureRecognizers: <
                                                  Factory<
                                                      OneSequenceGestureRecognizer>>[
                                                new Factory<
                                                    OneSequenceGestureRecognizer>(
                                                  () =>
                                                      new EagerGestureRecognizer(),
                                                ),
                                              ].toSet(),
                                              markers: _markers,
                                              onCameraMove: (CameraPosition
                                                  cameraPosition) {
                                                print(cameraPosition.zoom);
                                              },
                                              zoomControlsEnabled: false,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                      target: LatLng(
                                                          position.latitude,
                                                          position.longitude),
                                                      zoom: 12),
                                            ),
                                    ),
                                  )),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text(
                                    "Best Project",
                                    style: TextStyle(
                                      color: kGry,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 220,
                                  child: isBestHouseLoading
                                      ? Container(
                                          color: Colors.white,
                                          child: Center(
                                            child: SpinKitDualRing(
                                              color: kBlueText,
                                              size: 50.0,
                                            ),
                                          ),
                                        )
                                      : _houseMainModel.response.isEmpty
                                          ? Container(
                                              child: Center(
                                                  child: Text(
                                                      "No Home available ")),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              // itemCount:_houseMainModel.response.length,
                                              itemCount: _houseMainModel.response.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    height: 200,
                                                    width: 200,
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "-----------------house in home ID:  ${_houseMainModel.response[index].id}-------------------");
                                                          Navigator.push(context, MaterialPageRoute(builder: (context){return DetailScreen( cID: _houseMainModel.response[index].id,);}));
                                                      },
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                        elevation: 5,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: const Radius
                                                                            .circular(
                                                                        15.0),
                                                                    topRight:
                                                                        const Radius.circular(
                                                                            15.0),
                                                                  ),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(_houseMainModel
                                                                        .response[
                                                                            index]
                                                                        .mainIcon),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        showAlertDialog(
                                                                            context);
                                                                        String strCatId = _houseMainModel
                                                                            .response[index]
                                                                            .id;
                                                                        print(
                                                                            "---------click heart C_id $strCatId  and UserId $userId----------------");
                                                                        print(
                                                                            "----------ischeck ${_houseMainModel.response[index].ischeck}--------------");
                                                                        var connectivityResult =
                                                                            await (Connectivity().checkConnectivity());
                                                                        if (connectivityResult == ConnectivityResult.mobile ||
                                                                            connectivityResult ==
                                                                                ConnectivityResult.wifi) {
                                                                          if (_houseMainModel
                                                                              .response[index]
                                                                              .ischeck) {
                                                                            setFavoriteIHouse(
                                                                              userId,
                                                                              strCatId,
                                                                              "uf",
                                                                              context,
                                                                            );
                                                                            print("----------uf--------------");
                                                                          } else {
                                                                            setFavoriteIHouse(
                                                                                userId,
                                                                                strCatId,
                                                                                "add",
                                                                                context);
                                                                            print("----------add--------------");
                                                                          }
                                                                        } else {
                                                                          Navigator.pop(
                                                                              context);
                                                                          Scaffold.of(context)
                                                                              .showSnackBar(SnackBar(content: Text("Mobile is not Connected to Internet")));
                                                                        }
                                                                      },
                                                                      child: _houseMainModel
                                                                              .response[index]
                                                                              .ischeck
                                                                          ? Icon(
                                                                              FontAwesomeIcons.solidHeart,
                                                                              color: kBlueText,
                                                                            )
                                                                          : Icon(
                                                                              FontAwesomeIcons.heart,
                                                                              color: kBlueText,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child: Text(
                                                                          _houseMainModel
                                                                              .response[
                                                                                  index]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              color:
                                                                                  kGry),
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          FontAwesomeIcons
                                                                              .mapMarkerAlt,
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            // "Montacute TA15 6XP, United",
                                                                            _houseMainModel.response[index].location,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              },
                                            ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text(
                                    "New Arrivel",
                                    style: TextStyle(
                                      color: kGry,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 220,
                                    child: isNewHouseLoading
                                        ? Container(
                                            color: Colors.white,
                                            child: Center(
                                              child: SpinKitDualRing(
                                                color: kBlueText,
                                                size: 50.0,
                                              ),
                                            ),
                                          )
                                        : _houseNewHouse.response.isEmpty
                                            ? Container(
                                                child: Center(
                                                    child: Text(
                                                        "No Home available ")),
                                              )
                                            : ListView.builder(
                                                itemCount: _houseNewHouse
                                                    .response.length,
                                                // itemCount:30,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      print(
                                                          "-----------------house in home ID:  ${_houseNewHouse.response[index].id}-------------------");
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return DetailScreen(
                                                          cID: _houseNewHouse
                                                              .response[index]
                                                              .id,
                                                        );
                                                      }));
                                                    },
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      elevation: 5,
                                                      child: Container(
                                                        height: 100,
                                                        width: double.infinity,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: const Radius
                                                                              .circular(
                                                                          10.0),
                                                                      bottomLeft:
                                                                          const Radius.circular(
                                                                              10.0),
                                                                    ),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(_houseNewHouse
                                                                          .response[
                                                                              index]
                                                                          .mainIcon),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                )),
                                                            Expanded(
                                                                flex: 3,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          _houseNewHouse
                                                                              .response[
                                                                                  index]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              color:
                                                                                  kGry),
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              FontAwesomeIcons.mapMarkerAlt,
                                                                              size: 12,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                _houseNewHouse.response[index].location,
                                                                                style: TextStyle(fontSize: 12),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  FontAwesomeIcons.borderAll,
                                                                                  size: 12,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Container(
                                                                                  child: Text(
                                                                                    " ${_houseNewHouse.response[index].area}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    //  '2100 sqft',
                                                                                    style: TextStyle(fontSize: 12),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  FontAwesomeIcons.bed,
                                                                                  size: 12,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  '${_houseNewHouse.response[index].bedroom} bedrooms',

                                                                                  //  "3 bedrooms",
                                                                                  style: TextStyle(fontSize: 12),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }))
                              ],
                            ),
                          ),
                        ),
                      )),
        ));
  }
}
