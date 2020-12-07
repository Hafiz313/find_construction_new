import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/models/code_verification_models.dart';
import 'package:find_construction_new/models/login_models.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'conformed_password_screen.dart';

class CodeVerificationScreen extends StatefulWidget {
  static const id = "code_verification_screen";

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

Future<CodeVerificationModel> codeVerified(String code, String id) async {
  final String apiUrl = "https://construction.bazaaaar.com/passwordRecover.php";
  final response = await http.post(apiUrl, body: {"code": code, "id": id});
  if (response.statusCode == 200) {
    final String responseString = response.body;
    print(
        "------------------verification re: ${response.body}---------------------");
    return codeVerificationModelFromJson(responseString);
  } else {
    return null;
  }
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  var _formKey = GlobalKey<FormState>();
  String strTitle = "Verification";
  String strDescription = "Enter code form ";
  String strLabelText = 'Code';
  String strEmail;

  String strCode;

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('UserId');
    return stringValue;
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('forgetUserEmail');
    setState(() {
      strEmail = email;
    });
    print("-------------$strEmail--------------------");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
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
                              strTitle,
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
                              "$strDescription $strEmail",
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
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kLightGry)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: kLightGry)),
                          labelText: strLabelText,
                          labelStyle: TextStyle(color: kLightGry)),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Empty";
                        }
                        if (value.length >= 4) {
                          strCode = value.toString().trim();
                        } else
                          return "Must 4 digits";
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
                          if (_formKey.currentState.validate()) {
                            showAlertDialog(context);
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi) {
                              String id = await getValue() ?? "";
                              print(
                                  "------------------verification code: $strCode and id $id--------------");
                              CodeVerificationModel codeVeri = await codeVerified(strCode, id);

                              if (codeVeri.status) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text(codeVeri.message)));
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  preferences.remove('codeVerificationStatus');
                                });
                                print(
                                    "----------after remove SP : $strEmail-------------");
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, ConfermedPasswordScreen.id);
                              } else
                                Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text(codeVeri.message)));
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
