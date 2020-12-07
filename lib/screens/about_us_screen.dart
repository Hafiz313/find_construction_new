import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsScreen extends StatefulWidget {
  static const id = "about_us_screen";

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool isLoading=true;
  bool isInterNetCheck=true;
  final _key = UniqueKey();
  // ignore: non_constant_identifier_names
  Future<void>InternetCheck() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
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
      appBar: AppBar(title: Text("About Us"),),
      body: isInterNetCheck ?
      Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Mobile is not Connected to Internet",style:TextStyle(color: Colors.black),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(onTap:(){Navigator.pushReplacementNamed(context, AboutUsScreen.id);},child: Text("Retry",style:TextStyle(color:kBlueText ),)),
              ),
            ],
          ),
        ),
      ):Center(
        child:
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WebView(

                  key:  _key,
                  initialUrl: 'https://construction.bazaaaar.com/about_us.php',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish){
                    setState(() {
                      isLoading= false;
                    });
                  }
              ),
            ) ,isLoading ? Center( child: CircularProgressIndicator(),)
                : Stack(),
          ],
        )
      ),
    );
  }
}
