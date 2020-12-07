import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/models/login_models.dart';
import 'package:find_construction_new/screens/registration_screen.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;

import 'forget_screen.dart';
import 'home_Screen.dart';


class LoginScreen extends StatefulWidget {
  static const id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future<LoginModel> createLogin(String email, String password) async {
  final String apiUrl = "https://construction.bazaaaar.com/signin.php";
  final response =
      await http.post(apiUrl, body: {"email": email, "password": password});
  if (response.statusCode == 200) {
    final String responseString = response.body;
    print("-----------------LoginResponse (lognin screen) ${response.body}------------------");

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
Future<LoginModel> createSinUp(String name, String email,String phone,String source,String image) async {
  final String apiUrl = "https://construction.bazaaaar.com/signup.php";
  final response = await http.post(apiUrl, body: {
    "name": name,
    "phone": phone,
    "address": "",
    "email": email,
    "password": "123",
    "conpassword": "123",
    "source": source,
    "url": image,
  });
  if (response.statusCode == 200) {
    final String responseString = response.body;
    print("----------------respnse ${response.body}------------");
    return loginModelFromJson(responseString);
  } else {
    return null;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _load = false;
  var _formKey = GlobalKey<FormState>();
  LoginModel _loginModel;
  String strEmail, strPassword;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();

  /*
   login() async{
    var currentState= globalKey.currentState;
    if(currentState.validate()){
      currentState.save();
      FirebaseAuth firebaseAuth=FirebaseAuth.instance;
      try {

        AuthResult authResult=await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        FirebaseUser user=authResult.user;
        Navigator.pop(context);
      }catch(e){
        print(e);
      }
    }else{

    }
  }
*/
  @override
  void initState() {
   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    super.initState();
  }

  /*  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';*/

/*  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!

         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }*/
  /*Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }*/


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
            child: Center(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        "Log in",
                        style: TextStyle(color: kBlueText, fontSize: 30),
                      ),
                      SizedBox(
                        height: 60,
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
                            else if (emailValidation(value.trim())) {
                              strEmail = value.toString().trim();
                            } else
                              return "Invalid Email";
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: true,
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
                            return "Empty !";
                          } else
                            strPassword = value.toString().trim();
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
                          splashColor: kButtonBG,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              showAlertDialog(context);
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

                                  print("email: $strEmail and Password $strPassword");
                                  LoginModel login = await createLogin(strEmail, strPassword);
                                  if (login.status) {

                                    setState(() {
                                      _loginModel = login;
                                    });
                                    save(_loginModel);
                                    print(
                                        "---------login ${_loginModel.response}----------");
                                    Navigator.pop(context);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(_loginModel.message)));
                                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                                  }
                                  else{
                                    Navigator.pop(context);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(login.message)));

                                  }

                                }
                                else{
                                  Navigator.pop(context);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Mobile is not Connected to Internet")));
                                }

                            }
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, ForgetScreen.id);
                          },
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(color: kLightGry, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              Navigator.pushReplacementNamed(
                                  context, RegistrationScreen.id);
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: kBlueText, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 20.0),
                              child: Divider(
                                color: kGry,
                                height: 36,
                              )),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(color: kGry),
                        ),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              child: Divider(
                                color: kGry,
                                height: 36,
                              )),
                        ),
                      ]),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text('Sign up with social network'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  try {
                                    showAlertDialog(context);
                                    _fbLogin();
                                    print("facebook login");
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image(
                                      image: AssetImage('images/fb.png'),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  try {
                                    _googleSignIn.signOut();
                                    showAlertDialog(context);
                                    await _googleSignIn
                                        .signIn()
                                        .then((value) async {
                                      final String name =
                                          _googleSignIn.currentUser.displayName;
                                      final String email =
                                          _googleSignIn.currentUser.email;
                                      final String id =
                                          _googleSignIn.currentUser.id;
                                      final String pic = _googleSignIn.currentUser.photoUrl;
                                      showAlertDialog(context);
                                      LoginModel login = await createSinUp(name, email,"","google",pic);
                                      setState(() {
                                        _loginModel = login;
                                      });
                                      save(_loginModel);
                                      if(_loginModel.status){
                                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(_loginModel.message)));
                                      }


                                      print(
                                          "-----------------name ${_loginModel.status}------------------------");
                                      print(
                                          "-----------------email $email-----------------------");
                                      print(
                                          "------------------id $id---------------------------");
                                      print(
                                          "-----------------picture $pic----------------------");

                                    });
                                  } catch (err) {
                                    print(
                                        "----------google login error ${err}----------------------");
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("Error $err")));
                                  }
                                },
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image(
                                      image: AssetImage('images/gplus.png'),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _fbLogin() async {

    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final fbToken = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),email&access_token=$fbToken');
        print("------------token$fbToken----------------");
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile.toString());
        final String name = profile['name'];
        final String gid = profile['id'];
        final String pic = profile["picture"]["data"]["url"];
        final String email = profile["email"];
        final String password = "";
        print("------------name :$name, email :$email--------------");
        print("-------------pic : $pic-------------");
        LoginModel login = await createSinUp(name, email,"","facebook",pic);
        setState(() {
          _loginModel = login;
          print("---------------${_loginModel.message}");
        });
        save(_loginModel);
        if(_loginModel.status){
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
        else{
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "${_loginModel.message}");
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        Fluttertoast.showToast(msg: "Facebook login cancelled by User");
        Navigator.pop(context);


        break;
      case FacebookLoginStatus.error:
        Fluttertoast.showToast(msg: result.errorMessage);
        Navigator.pop(context);
        break;
    }
  }
}
