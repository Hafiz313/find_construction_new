import 'package:flutter/material.dart';



final Color kBlueText = HexColor("#535BFE");
final Color kGry = HexColor("#404852");
final Color kLightGry = HexColor("#7A7A7A");
final Color kGryBG = HexColor("#dee3e7");
final Color kButtonBG = HexColor("#535bfe");


/*final Color kColorPrimary = HexColor("#D82B2B");
final Color kColorAccent = HexColor("#252A2D");
final Color kColorGoogle = HexColor("#4385f6");
final Color kColorFacebook = HexColor("#3b5998");
final Color kColorFB = HexColor("#3b5796");
final Color kColorGN = HexColor("#57399d");
final Color kColorScaffoldBg = HexColor("#181820");*/


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    String _hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (_hexColor.length == 6) {
      _hexColor = "FF$_hexColor";
    }
    return int.parse(_hexColor, radix: 16);
  }
}