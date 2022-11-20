import 'dart:ui';

import 'package:Yemenaman/screensadmin/chatrooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/model_items.dart';
import '../constants.dart';
import '../mainPage.dart';
import '../widgets/auth.dart';
import '../widgets/title_text.dart';
import 'home&details/details.dart';
import 'login_screen/welcome page.dart';

class posts extends StatefulWidget {
  posts({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _postsState createState() => _postsState();
}

class _postsState extends State<posts> {



  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: OurColor.kPrimaryColor,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.greenAccent,
      unselectedItemColor: OurColor.titleTextColor,
      currentIndex: 1,
      onTap: (value) {
        if (value == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
        if (value == 1) {

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





  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              _scaffoldKeyposts.currentState!.openDrawer();
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
        margin: EdgeInsets.only(top: 10, right: 10),
        child: Row(
          children: <Widget>[
            Spacer(),
            TitleText(
              text: 'المنشورات',
              fontSize: 27,
              fontWeight: FontWeight.w400,
            ),
          ],
        ));
  }



  final GlobalKey<ScaffoldState> _scaffoldKeyposts = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColor.kBackgroundColor,
      key: _scaffoldKeyposts,
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
                height: AppTheme.fullHeight(context) - 80,
                color: Colors.black12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),
                    _title(),
                    Expanded(
                      child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          switchInCurve: Curves.easeInToLinear,
                          switchOutCurve: Curves.easeOutBack,
                          child: homebirsim()),
                    )
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

class homebirsim extends StatefulWidget {
  homebirsim({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _homebirsimState createState() => _homebirsimState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _homebirsimState extends State<homebirsim> {
  String name = '';
    final deviceWidth = (window.physicalSize.shortestSide / window.devicePixelRatio);
  Widget _icon(IconData icon, {Color color = OurColor.kBackgroundColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _productWidget() {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height / 0.5,
          padding: EdgeInsets.only(right: 10, left: 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                                item: snapshot.data!.docs[index],)),
                      );
                    },
                    child: SizedBox(
                      height: 250,
                      width: 300,
                      child: Card(
                        color: OurColor.kPrimaryColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: ModelItems(
                                    index: index,
                                    imageWidth: deviceWidth,
                                    imageOffset: 0.0,
                                    indexFactor: (10 + 270) / deviceWidth,
                                    hero: snapshot.data!.docs[index]["image"]),
                              ),
                            ),
                            Container(
                                alignment: Alignment.topRight,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(snapshot.data!.docs[index]["title"],
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.getFont(
                                      'Markazi Text',
                                      color: OurColor.titleTextColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              // color: Colors.green,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  left: 15, bottom: 10, right: 10),
                              child: Text("...المزيد",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.getFont(
                                    'Markazi Text',
                                    color: OurColor.subTitleTextColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                    
                    
                  },
                );
              })),
    );
  }



  Widget _title() {
    return Container(
        margin: EdgeInsets.only(top: 10, right: 10),
        child: Row(
          children: <Widget>[
            Spacer(),
            TitleText(
              text: 'المحاصيل',
              fontSize: 27,
              fontWeight: FontWeight.w400,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 210,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _productWidget(),
          ],
        ),
      ),
    );
  }
}
