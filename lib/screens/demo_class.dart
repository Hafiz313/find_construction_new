import 'package:find_construction_new/screens/favorite_house_screen.dart';
import 'package:find_construction_new/screens/home_Screen.dart';
import 'package:find_construction_new/screens/profile_screen.dart';
import 'package:flutter/material.dart';



class DemoClass extends StatefulWidget {
  static const id= "demo_class";
  DemoClass({Key key}) : super(key: key);

  @override
  _DemoClassState createState() => _DemoClassState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DemoClassState extends State<DemoClass> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const  _widgetOptions = [
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body:  Stack(
        children: <Widget>[
           Offstage(
            offstage: _selectedIndex != 0,
            child: new TickerMode(
              enabled: _selectedIndex == 0,
              child: new MaterialApp(home: HomeScreen()),
            ),
          ),
           Offstage(
            offstage: _selectedIndex != 1,
            child: new TickerMode(
              enabled: _selectedIndex == 1,
              child: new MaterialApp(home:  FavoriteHouseScreen()),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: new TickerMode(
              enabled: _selectedIndex == 2,
              child: new MaterialApp(home:  ProfileScreen()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
