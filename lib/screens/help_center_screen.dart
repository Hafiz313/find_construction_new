import 'package:connectivity/connectivity.dart';
import 'package:find_construction_new/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpCenterScreen extends StatefulWidget {
  static const id = "help_center_screen";
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool isLoading=true;
  final _key = UniqueKey();
  bool isInterNetCheck=true;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetCheck();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help center"),),
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
                child: InkWell(onTap:(){Navigator.pushReplacementNamed(context, HelpCenterScreen.id);},child: Text("Retry",style:TextStyle(color:kBlueText ),)),
              ),
            ],
          ),
        ),
      ):
      Center(
        child:
        Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WebView(

                      key:  _key,
                      initialUrl: 'https://construction.bazaaaar.com/help_center.php',
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
      ),
    );
  }
}
