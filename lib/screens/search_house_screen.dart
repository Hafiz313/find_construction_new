import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_construction_new/models/favorite_models.dart' as favorite;
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'detail_screen.dart';


class SearchHouseScreen extends StatefulWidget {
  static const id= "search_house_screen";

  @override
  _SearchHouseScreenState createState() => _SearchHouseScreenState();
}

class _SearchHouseScreenState extends State<SearchHouseScreen> {
  // ignore: non_constant_identifier_names
  List<String> house_names = List();
  String query = '';
  bool isLoading=true;
  favorite.FavoriteModel _favoriteModel;
  Future<favorite.FavoriteModel> getFavoriteHome(String userId) async {
    final String apiUrl = "https://construction.bazaaaar.com/totalrecord.php";
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(
          "-----------favorite response : ${response.body}--------------------");
      setState(() {
        _favoriteModel = favorite.favoriteModelFromJson(responseString);
        isLoading=false;

      });
      addName();
      _MySearchDelegate(house_names);
      return favorite.favoriteModelFromJson(responseString);
    } else {
      setState(() {
        isLoading=false;
      });
      return null;
    }
  }
  Future<void> readID() async {
    String userId;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId= json.decode(prefs.getString("login_response"))["response"]["id"]?? "";
    });
    print("---------------------user id in favorite $userId-------------------------");

    getFavoriteHome("68");
  }
  void addName(){
    for (int i = 0; i < _favoriteModel.response.length; i++) {
      String  name = _favoriteModel.response[i].name;
      house_names.add(name);
      print("------------$name------------");

    }
  }
  bool isInterNetCheck=true;
  // ignore: non_constant_identifier_names
  Future<void>InternetCheck() async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      readID();
      setState(() {
        isInterNetCheck= false;
        print("availabel");
      });
    }
    else{
      setState(() {
        isInterNetCheck= true;
        print("ont availabel");
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetCheck();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("All house")),
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
      body: Container(
        child: isInterNetCheck ?
        Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Mobile is not Connected to Internet",style:TextStyle(color: Colors.black),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(onTap:(){Navigator.pushReplacementNamed(context, SearchHouseScreen.id);},child: Text("Retry",style:TextStyle(color:kBlueText ),)),
                ),
              ],
            ),
          ),
        ): _buildList(''),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList(_searchText) {
    final searchItems = query.isEmpty ? house_names : house_names
        .where((c) => c.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return isLoading? Container(
      color: Colors.white,
      child: Center(
        child: SpinKitDualRing(
          color:kBlueText,
          size: 50.0,
        ),
      ),
    ): Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(searchItems.length, (index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              child: InkWell(
                onTap: () {
                  print("-----------------house in home ID:  ${_favoriteModel.response[index].id }-------------------");
                  Navigator.push(context, MaterialPageRoute(builder: (context){return DetailScreen( cID: _favoriteModel.response[index].id,);}));
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
                            image: NetworkImage(
                                _favoriteModel.response[index].mainIcon),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.topRight,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: (){

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
                                      _favoriteModel.response[index].location,
                                      style: TextStyle(color: kGry),
                                      overflow: TextOverflow.ellipsis),
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
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("-------------buildSuggestions : $query----------------");
   // final suggestions = query.isEmpty ? _history : city_names.where((c) => c.toLowerCase().contains(query)).toList();
    final suggestions =  house_names.where((c) => c.toLowerCase().contains(query)).toList();

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