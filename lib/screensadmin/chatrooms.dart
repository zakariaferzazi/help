import 'dart:async';

import 'package:Yemenaman/mainPage.dart';
import 'package:Yemenaman/screensadmin/posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Yemenaman/screensadmin/search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/auth.dart';
import '../widgets/helperfunctions.dart';
import '../widgets/title_text.dart';
import 'chat.dart';
import 'database.dart';
import 'login_screen/welcome page.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream? chatRooms;
  int _selectedIndex = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffolchatroomKey =
      new GlobalKey<ScaffoldState>();

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: OurColor.kPrimaryColor,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.greenAccent,
      unselectedItemColor: OurColor.titleTextColor,
      currentIndex: 2,
      onTap: (value) {
        if (value == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
        if (value == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => posts()));
        }
        if (value == 2) {

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
              _scaffolchatroomKey.currentState!.openDrawer();
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




  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.docs[index]['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.docs[index]["chatRoomId"],
                    uid: snapshot.data.docs[index][snapshot
                            .data.docs[index]['chatRoomId']
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, "") +
                        "uid"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }





  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColor.kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Container(
              child: chatRoomsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      key: _scaffolchatroomKey,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.newspaper_outlined),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => posts()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String uid;


  ChatRoomsTile({
    required this.userName,
    required this.chatRoomId,
    required this.uid,
  });
  // Future<String> getPicurl() async {
  //   Reference ref =
  //       FirebaseStorage.instance.ref().child("images/${uid}");
  //   var url = (await ref.getDownloadURL());
  //   return url;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2,bottom: 2),
      color: Color.fromRGBO(22,34,71,1.000),
      child: InkWell(
        onTap: () async {
          var currectuid = FirebaseAuth.instance.currentUser!.uid;
          FirebaseFirestore.instance
              .collection("chatRoom")
              .where(chatRoomId)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference
                  .update({userName + "newmessage": "false"});
            });
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                      otheruid: uid,
                      otherusername: userName)));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipOval(
                      child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: ClipOval(
                child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Image.network(
                  "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
                  fit: BoxFit.contain,
                )),
          ),
                  )),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users1')
                        .where("uid", isEqualTo: uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return (snapshot.data!.docs[0]["status"] ==
                                "online")
                            ? Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.green, width: 3),
                                  ),
                                ),
                              )
                            : Container();
                      }
                      if (snapshot.hasError) {
                        return Text("error");
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 12,
              ),
              Text(userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 18,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
              SizedBox(
                width: 30,
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatRoom')
                    .doc(chatRoomId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data![userName + "newmessage"] == "true"
                        ? Image.asset("assets/images/newmessage.png",
                            width: 40, height: 40)
                        : Container();
                  }
                  return Container();
                },
              ),
              Spacer(),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users1')
                    .where("uid", isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return (snapshot.data!.docs[0]["status"] == "online")
                        ? Text(
                            "online",
                            style: TextStyle(color: Colors.green),
                          )
                        : Text(
                            "offline",
                            style: TextStyle(color: Colors.red),
                          );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
