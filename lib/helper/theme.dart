import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

const primaryColor = Color.fromARGB(255, 5, 25, 93);
const secondaryColor = Color(0xffff4400);
const thirdColor = Color(0xf0ff4444);
const nextColor = Color(0xFFfa833d);
const buttonColor = Color(0xFFFFFFFF);
const buttonBkColor = Color.fromARGB(255, 23, 110, 106);
const labelColor = Color(0xFF757575);
const barchartColor = Color(0xff845b82);
const kBackgroundColor =  Color(0xffFAFAFA);
const kGrayColor = const Color(0xff9698A9);

const TextStyle labelStyle =
    TextStyle(fontSize: 17, color: primaryColor, fontWeight: FontWeight.w500);
const TextStyle labelStyleMM = TextStyle(
    fontSize: 17,
    color: primaryColor,
    fontWeight: FontWeight.w500,
    height: 1,
    fontFamily: "Pyidaungsu");
const TextStyle subMenuStyle =
    TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500);
const TextStyle subMenuStyleMM = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontFamily: "Pyidaungsu");

const TextStyle welcomeLabelStyle =
    TextStyle(fontSize: 23, color: primaryColor, fontWeight: FontWeight.w500);
const TextStyle welcomeSubLabelStyle =
    TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500);
const TextStyle siginButtonStyle =
    TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500);

TextStyle newLabelStyle(
    {Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    bool underline = false}) {
  return TextStyle(
      fontSize: fontSize ?? 13,
      color: color ?? secondaryColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      decoration: underline ? TextDecoration.underline : TextDecoration.none);
}

TextStyle newLabelStyleMM(
    {Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    bool underline = false}) {
  return TextStyle(
      wordSpacing: 0,
      fontSize: fontSize ?? 13,
      color: color ?? secondaryColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      letterSpacing: 0,
      fontFamily: "Pyidaungsu");
}

const TextStyle photoLabelStyle =
    TextStyle(color: Colors.black, fontSize: 13.0);
const TextStyle photoLabelStyleMM =
    TextStyle(color: Colors.black, fontSize: 13.0, fontFamily: "Pyidaungsu");
const TextStyle textStyle =
    TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500);
const TextStyle textStyleOdd = TextStyle(
    fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w500);
const TextStyle textStrikeStyle = TextStyle(
  fontSize: 15,
  color: Colors.black87,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.lineThrough,
);
const TextStyle textHighlightRedStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  backgroundColor: Colors.red,
);
const TextStyle textHighlightGreenStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  backgroundColor: Colors.green,
);
const TextStyle textHighlightBlueStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  backgroundColor: Colors.blue,
);

const TextStyle subTitleStyle =
    TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500);

final BoxDecoration tableRowOdd = BoxDecoration(
  color: Color(0x1F000000),
);
final BoxDecoration tableRowEven = BoxDecoration(
  color: Colors.white54,
);

class LoginColors {
  const LoginColors();

  static const Color loginGradientStart = const Color(0xfff00a21);
  static const Color loginGradientEnd = const Color(0xfff00a21);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
