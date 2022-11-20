import 'package:flutter/material.dart';

class User {
  final String uid;
  User({required this.uid});
}

class Constants {
  static String myName = "";
  static String chatRoomId = "";
  static String myEmail = "";
}

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);
class OurColor {
static const kBackgroundColor = Color.fromRGBO(14,14,16,1.000);
static const kPrimaryColor = Color.fromARGB(255, 51, 50, 50);
static const kSecondaryColor = Color.fromRGBO(28,30,31,1.000);

static const Color titleTextColor = Color.fromRGBO(252,251,252,1.000);
static const Color subTitleTextColor = Color.fromRGBO(217,219,221,1.000);

static const Color black = Color(0xff20262C);
static const Color lightblack = Color(0xff5F5F60);
}

class AppTheme {



  static TextStyle titleStyle =
      const TextStyle(color: OurColor.titleTextColor, fontSize: 16);
  static TextStyle subTitleStyle =
      const TextStyle(color: OurColor.subTitleTextColor, fontSize: 12);

  static TextStyle h1Style =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style = const TextStyle(fontSize: 18);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  
  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
