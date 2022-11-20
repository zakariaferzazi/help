

import 'package:Yemenaman/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/title_text.dart';

class about_us extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _about_usState();
  }
}

class _about_usState extends State<about_us> {
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final Uri _url = Uri.parse("https://twitter.com/priv3t3");

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
                          child: Image.asset("assets/images/logo.png"))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                children: [
                  Text(
                      "تختلف عقوبة الابتزاز الإلكتروني من دولة لأخرى حسب نص القانون في هذه الدولة، ولكن عموماً ما تكون العقوبة بالحبس حسب حجم الضرر الذي ألحقه بالضحية",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont('Markazi Text',
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: OurColor.titleTextColor)),
                  Text(
                      "أول خطوة يجب القيام بها عند تعرُّضك للابتزاز الإلكتروني، هي ضبط الأعصاب والتروي، وعدم فقدان السيطرة أو الخوف، أو التصرف بشكل هيستيري غير مدروس، فهي مشكلة لها حل، ويتعرض الكثيرون يومياً للتهديد والابتزاز، ويتم حل مشكلاتهم ومعالجتها نهائياً فقط عن طريق التقدم ببلاغ على تطبيقنا",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont('Markazi Text',
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: OurColor.titleTextColor)),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .05,
              width: width,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Icon(
                        FontAwesomeIcons.twitter,
                        color: OurColor.subTitleTextColor,
                      ),
                    ),
                    Center(
                      child: Text(
                        "@priv3t3",
                        style: TextStyle(
                            color: OurColor.subTitleTextColor, fontSize: 20),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launchUrl(_url);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Text(
                          "Follow",
                          style: TextStyle(color: OurColor.subTitleTextColor),
                        )),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
