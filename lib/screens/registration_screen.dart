
import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/models/login_models.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'home_Screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

Future<LoginModel> createSinUp(String name, String phone, String address,
    String email, String password,String conPassword) async {
  final String apiUrl = "https://construction.bazaaaar.com/signup.php";
  final response = await http.post(apiUrl, body: {
    "name": name,
    "phone": phone,
    "address": address,
    "email": email,
    "password": password,
    "conpassword": conPassword,
    "source": "",
    "image": "",
  });
  if (response.statusCode == 200) {
    final String responseString = response.body;
    print("----------------respnse ${response.body}------------");
    return loginModelFromJson(responseString);
  } else {
    return null;
  }
}

emailValidation(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (regex.hasMatch(email)) {
    return true;
  } else {
    return false;
  }
}
showAlertDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 10),child:Text(" Loading" )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  LoginModel _loginModel;
  String strName,
      strEmail,
      strAddress,
      strPhone,
      strConformPassword,
      strPassword;
  String empty ="Empty !";
  save(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_response", json.encode(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Registration",
                      style: TextStyle(color: kBlueText, fontSize: 30),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: 'Name ',
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return empty;
                        } else
                          strName = value.toString().trim();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: 'Email ',
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty)
                          return "Empty !";
                        else if (emailValidation(value.trim())){
                          strEmail= value.toString().trim();
                        }
                        else
                          return "Invalid Email";
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: 'Address ',
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return empty;
                        } else
                          strAddress = value.toString().trim();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: 'Telephone ',
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return empty;
                        }else if(value.length <10)
                          return "Invalid phone";
                        else
                          strPhone = value.toString().trim();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      controller: _pass,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: 'Password ',
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return empty;
                        } else
                          strPassword = value.toString().trim();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      controller: _confirmPass,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: 'Confrim Password ',
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String val) {
                        if (val.isEmpty) return empty;
                        else strConformPassword = val.toString().trim();
                        if (val != _pass.text) return 'Not Match';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        color: kBlueText,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(10.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            showAlertDialog(context);
                            var connectivityResult = await (Connectivity().checkConnectivity());
                           if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            LoginModel sinUp = await createSinUp(strName, strPhone, strAddress, strEmail, strPassword, strConformPassword);
                            if (sinUp.status) {
                            setState(() {
                             _loginModel = sinUp;
                            });

                            print("--------name:$strName, phone $strPhone, address $strAddress, $strEmail, $strPassword, $strConformPassword-------------------");
                            print("---------------lgon modals : ${_loginModel.status}---------");


                              save(_loginModel);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(_loginModel.message)));
                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                            } else
                              Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(_loginModel.message)));
                          }
                           else{
                             Navigator.pop(context);
                             Scaffold.of(context).showSnackBar(SnackBar(
                                 content: Text("Mobile is not Connected to Internet")));
                           }


                          }
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 15, color: kGry),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: Text(
                            "Sign in",
                            style:
                                TextStyle(color: kBlueText, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
