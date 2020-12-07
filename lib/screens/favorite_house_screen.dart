import 'dart:convert';
import 'package:find_construction_new/models/house_main_models.dart' as house;
import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/screens/home_Screen.dart';
import 'package:find_construction_new/screens/profile_screen.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_construction_new/models/favorite_models.dart' as favorite;
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'detail_screen.dart';

class FavoriteHouseScreen extends StatefulWidget {
  static const id = "favorite_house_screen";

  @override
  _FavoriteHouseScreenState createState() => _FavoriteHouseScreenState();
}

class _FavoriteHouseScreenState extends State<FavoriteHouseScreen> {
  List<String> house_names = List();
  String query = '';
  bool isLoading = true;
  bool isInterNetCheck = true;
  String userId;
  int _selectedIndex = 0;
  Future<void> read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = json.decode(prefs.getString("login_response"))["response"][0]
      ["id"] ??
          "";
    });
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

  // ignore: non_constant_identifier_names
  Future<void> InternetCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      readID();
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

  favorite.FavoriteModel _favoriteModel;

  Future<favorite.FavoriteModel> unFavoriteHome(
      String userId, String houseId) async {
    final String apiUrl = "https://construction.bazaaaar.com/favorite.php";
    final response = await http
        .post(apiUrl, body: {"uid": userId, "cid": houseId, "uf": ""});
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(
          "-----------favorite response : ${response.body}--------------------");

      setState(() {
        _favoriteModel = favorite.favoriteModelFromJson(responseString);
        isLoading = false;
      });
      addName();
      return favorite.favoriteModelFromJson(responseString);
    } else {
      setState(() {
        isLoading = false;
      });
      return null;
    }
  }

  Future<favorite.FavoriteModel> getFavoriteHome(String userId) async {
    final String apiUrl = "https://construction.bazaaaar.com/favorite.php";
    final response = await http.post(apiUrl, body: {"uid": userId, "get": ""});
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(
          "-----------favorite response : ${response.body}--------------------");

      setState(() {
        _favoriteModel = favorite.favoriteModelFromJson(responseString);
        isLoading = false;
      });
      addName();
      return favorite.favoriteModelFromJson(responseString);
    } else {
      setState(() {
        isLoading = false;
      });
      return null;
    }
  }

  Future<void> readID() async {
    String userId;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = json.decode(prefs.getString("login_response"))["response"][0]
              ["id"] ??
          "";
    });
    print(
        "---------------------user id in favorite $userId-------------------------");
    getFavoriteHome(userId);
  }

  void addName() {
    for (int i = 0; i < _favoriteModel.response.length; i++) {
      String name = _favoriteModel.response[i].name;
      house_names.add(name);
      print("------------$name------------");
    }
  }

  Future<house.HouseMainModel> setFavoriteIHouse(
      String userId, String catId, BuildContext context) async {
    final String apiUrl = "https://construction.bazaaaar.com/favorite.php";
    final response =
        await http.post(apiUrl, body: {"uid": userId, "cid": catId, "uf": ""});
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(
          "----------------------setFavoriteIHouse ${house.houseMainModelFromJson(responseString).message}----------------------------");

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, FavoriteHouseScreen.id);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(house.houseMainModelFromJson(responseString).message)));
      return house.houseMainModelFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetCheck();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Favorite")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String selected = await showSearch(
                  context: context, delegate: _MySearchDelegate(house_names));

              if (selected != null && selected != query) {
                setState(() {
                  query = selected;
                });
              }
            },
          )
        ],
      ),
      /* bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              switch (_selectedIndex) {
                case 0:
                // Navigator.pushReplacementNamed(context, ProfileScreen.id);
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context,HomeScreen.id);
                  break;
                case 2:
                  Navigator.pushNamed(context, ProfileScreen.id);
                  break;
              }
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.solidHeart),

                //   icon: Icon(FontAwesomeIcons.userAlt),
                title: Text('')),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Notifications'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userAlt),
              title: Text('Notifications'),
            ),
          ]),*/
      body: Container(
        child: isInterNetCheck
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
                                  context, FavoriteHouseScreen.id);
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
            : _buildList(''),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList(_searchText) {
    final searchItems = query.isEmpty
        ? house_names
        : house_names
            .where((c) => c.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: SpinKitDualRing(
                color: kBlueText,
                size: 50.0,
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: _favoriteModel.response.isEmpty
                ? Container(
                    color: Colors.white,
                    child: Center(
                        child: Text(
                      "Not Favorite House",
                      style: TextStyle(color: Colors.black),
                    )),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(searchItems.length, (index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            print(
                                "-----------------house in home ID:  ${_favoriteModel.response[index].id}-------------------");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailScreen(
                                cID: _favoriteModel.response[index].id,
                                checkScreen: "favorite",
                              );
                            }));
                          },
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15.0),
                                      topRight: const Radius.circular(15.0),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(_favoriteModel
                                          .response[index].mainIcon),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: () async {
                                          String strCatId = _favoriteModel
                                              .response[index]
                                              .id;
                                          var connectivityResult = await(
                                              Connectivity()
                                                  .checkConnectivity());
                                          if (connectivityResult ==
                                                  ConnectivityResult.mobile ||
                                              connectivityResult ==
                                                  ConnectivityResult.wifi) {
                                            showAlertDialog(context);
                                            setFavoriteIHouse(userId,strCatId,context);

                                          }
                                          else {
                                            Navigator.pop(
                                                context);
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(content: Text("Mobile is not Connected to Internet")));
                                          }
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.solidHeart,
                                          color: kBlueText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(searchItems[index],
                                            style: TextStyle(color: kGry),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                                _favoriteModel
                                                    .response[index].location,
                                                style: TextStyle(color: kGry),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ));

    /*ListView.builder(
      itemCount: searchItems.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text((searchItems[index])),
          leading: Icon(Icons.location_city),
//          subtitle: Text('Search'),
        );
      },
    );*/
  }
}

class _MySearchDelegate extends SearchDelegate<String> {
  // ignore: non_constant_identifier_names
  final List<String> house_names;

  _MySearchDelegate(this.house_names);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon((Icons.clear)),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Text(
        "Not search found",
        style: TextStyle(color: Colors.black),
      )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("-------------buildSuggestions : $query----------------");
    // final suggestions = query.isEmpty ? _history : city_names.where((c) => c.toLowerCase().contains(query)).toList();
    final suggestions =
        house_names.where((c) => c.toLowerCase().contains(query)).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: Text(suggestions[index]),
            onTap: () {
              showResults(context);
              close(context, suggestions[index]);
            },
          );
        });
  }
}
