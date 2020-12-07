import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/models/email_verification_model.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'code_verification_screen.dart';

class ForgetScreen extends StatefulWidget {
  static const id = "forget_screen";

  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

Future<EmailVerificationModel> createVerified(String email) async {
  final String apiUrl = "https://construction.bazaaaar.com/passwordRecover.php";
  final response = await http.post(apiUrl, body: {
    "femail": email,
  });
  if (response.statusCode == 200) {
    final String responseString = response.body;
    print(
        "--------------------email response ${response.body}----------------------");
    return emailVerificationModelFromJson(responseString);
  } else {
    return null;
  }
}

final String auth_token = "auth_token";

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

class _ForgetScreenState extends State<ForgetScreen> {
  var _formKey = GlobalKey<FormState>();
  EmailVerificationModel _emailVerificationModel;
  String strEmail;

  saveValue(String userId, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserId', userId);
    prefs.setString('forgetUserEmail', userEmail);
    prefs.setString('codeVerificationStatus', "true");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Builder(
            builder: (context) => Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('images/moble.png'),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              "Forget Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            child: Text(
                              "Please enter the email id you use at a time of registration to get password forget instruction.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
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
                        else if (emailValidation(value)) {
                          strEmail = value.toString().trim();
                        } else
                          return "Invalid Email";
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        color: kBlueText,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(10.0),
                        splashColor: kButtonBG,
                        onPressed: () async {
                          //Navigator.pushNamed(context, PasswordVerificationScreen.id);
                          if (_formKey.currentState.validate()) {
                            showAlertDialog(context);

                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi) {
                              EmailVerificationModel email = await createVerified(strEmail);
                              if (email.status) {
                              setState(() {
                                _emailVerificationModel = email;
                              });
                              print("email: $strEmail");


                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content:
                                        Text(_emailVerificationModel.message)));
                                saveValue(_emailVerificationModel.response.id,
                                    _emailVerificationModel.response.email);
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, CodeVerificationScreen.id);
                              } else
                                Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text(_emailVerificationModel.message)));
                            } else {
                              Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Mobile is not Connected to Internet")));
                            }
                          }
                        },
                        child: Text(
                          "Get Code",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
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
