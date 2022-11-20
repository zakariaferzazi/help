import 'package:Yemenaman/constants.dart';
import 'package:Yemenaman/screensuser/postsuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screensuser/databaseuser.dart';
import '../../widgets/helperfunctions.dart';

class VerifyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VerifyPageState();
  }
}

class _VerifyPageState extends State<VerifyPage> {
  final RoundedLoadingButtonController _btnController3 =
      RoundedLoadingButtonController();
  @override
  void initState() {
    super.initState();
    _btnController3.stop();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final Uri _url = Uri.parse("https://twitter.com/priv3t3");
    singUp() async {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        _btnController3.success();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => postsuser()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("المرجو تأكيد الحساب")));
        _btnController3.reset();
      }
    }

    signupbutton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: RoundedLoadingButton(
          color: Colors.greenAccent,
          successColor: Colors.amber,
          child: Text(
            "تأكيد".toUpperCase(),
            style: TextStyle(
                color: OurColor.kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          controller: _btnController3,
          onPressed: () async {
            singUp();
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: OurColor.kBackgroundColor,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .4,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [OurColor.titleTextColor, OurColor.kPrimaryColor],
                  ),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: MediaQuery.of(context).size.width * .60,
                          margin: EdgeInsets.all(30),
                          child: Image.asset("assets/images/verify.png"))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                children: [
                  Center(
                    child: Text("المرجو تأكيد الايميل الخاص بك",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont('Markazi Text',
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: OurColor.titleTextColor)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            signupbutton()
          ],
        ),
      ),
    );
  }
}
