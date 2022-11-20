import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/title_text.dart';
import 'Models/model.dart';
import 'constants.dart';
import 'package:Yemenaman/screensadmin/posts.dart';
import 'package:Yemenaman/widgets/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Yemenaman/screensadmin/chatrooms.dart';
import 'package:Yemenaman/screensadmin/login_screen/welcome%20page.dart';
import 'package:Yemenaman/widgets/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/title_text.dart';
import 'constants.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => posts(),
            ));
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => posts(),
          ));
    });

    super.initState();
  }

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              _scaffoldMainPageKey.currentState!.openDrawer();
            },
            child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: OurColor.lightblack,
                    borderRadius: BorderRadius.all(Radius.circular(13))),
                child: Icon(
                  Icons.sort,
                  color: Colors.black,
                )),
          ),

          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                color: OurColor.lightblack,
              ),
              child: CircleAvatar(
                backgroundColor: OurColor.lightblack,
                radius: 20,
                backgroundImage: AssetImage("assets/images/logo.png"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
        margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Spacer(),
            TitleText(
              text: 'ضحايا الابتزاز',
              fontSize: 27,
              fontWeight: FontWeight.w400,
            ),
          ],
        ));
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: OurColor.kPrimaryColor,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.greenAccent,
      unselectedItemColor: OurColor.titleTextColor,
      currentIndex: 0,
      onTap: (value) {
        if (value == 0) {}
        if (value == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => posts()));
        }
        if (value == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'المنشورات'),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.message), label: 'الرسائل'),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldMainPageKey =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMainPageKey,
      bottomNavigationBar: buildBottomNavigationBar(),
      drawer: Drawer(
        backgroundColor: OurColor.lightblack,
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: OurColor.lightblack,
              automaticallyImplyLeading: false,
              elevation: 0,
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 40.0),
                centerTitle: true,
                background: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.1),
                      ],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: TitleText(
                                text: "الرئيسية",
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              FontAwesomeIcons.home,
                              color: OurColor.titleTextColor,
                              size: 30,
                            )
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => posts()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TitleText(
                              text: "المنشورات",
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.article,
                              color: OurColor.titleTextColor,
                              size: 30,
                            )
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatRoom()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TitleText(
                              text: "الرسائل",
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              FontAwesomeIcons.message,
                              color: OurColor.titleTextColor,
                              size: 30,
                            )
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                                "الابتزاز الإلكتروني جريمة يفترض ان يكون طلب المساعدة في الحال, أنت لست وحدك في هدا",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.getFont(
                                  'Markazi Text',
                                  fontSize: 20,
                                  color: OurColor.subTitleTextColor,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 3,
                  ),

                  InkWell(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      await FirebaseFirestore.instance
                          .collection("users1")
                          .where("uid",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((querySnapshot) {
                        querySnapshot.docs.forEach((documentSnapshot) {
                          documentSnapshot.reference
                              .update({"status": "offline"});
                        });
                      });
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => welcomepage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              offset: Offset(0, 15)),
                        ],
                      ),
                      margin:
                          const EdgeInsets.only(right: 20, left: 20, top: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              TitleText(
                                text: "تسجيل الخروج",
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 90,
                color: OurColor.kSecondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),
                    _title(),
                    Expanded(child: MyHomePage())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  Widget _title() {
    return Container(
        margin: EdgeInsets.only(top: 10, right: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Spacer(),
            TitleText(
              text: 'أخر المنشورات',
              fontSize: 27,
              fontWeight: FontWeight.w400,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.fullHeight(context) - 80,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ModelBlacmailposts(),
            _title(),
            Modelposts()
          ],
        ),
      ),
    );
  }
}
