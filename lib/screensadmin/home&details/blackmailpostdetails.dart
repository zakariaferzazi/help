import 'dart:ui';

import 'package:Yemenaman/constants.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/src/intl/date_format.dart';

import '../chat.dart';
import '../database.dart';

class BlackMailPostdetails extends StatefulWidget {
  final item;

  const BlackMailPostdetails({super.key, this.item});

  @override
  State<BlackMailPostdetails> createState() => DBlackMailPostdetailsState();
}

class DBlackMailPostdetailsState extends State<BlackMailPostdetails> {
  final _controller = ScrollController();
  ScrollPhysics _physics = const ClampingScrollPhysics();
  bool appBarVAR = false;
  bool bottomBarImagesVAR = false;
  QuerySnapshot? otherusername;
  bool isLoading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future run() async {
    await Future.delayed(const Duration(milliseconds: 350));
    setState(() {
      appBarVAR = true;
      bottomBarImagesVAR = true;
    });
  }

  @override
  void initState() {
    super.initState();
    databaseMethods.searchByName(widget.item["victim name"]).then((snapshot) {
      otherusername = snapshot;
    });
    try {
      run();
    } catch (e) {
      debugPrint("$e");
    }
    _controller.addListener(() {
      if (_controller.position.pixels <= 100) {
        setState(() => _physics = const ClampingScrollPhysics());
      } else {
        setState(() => _physics = const BouncingScrollPhysics());
      }
    });
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage() async {
    final userName = await otherusername!.docs[0]["userName"];
    final otherUseruid = await otherusername!.docs[0]["uid"];
    Constants.chatRoomId = getChatRoomId(Constants.myName, userName);
    List<String> users = [Constants.myName, userName];
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": Constants.chatRoomId,
      Constants.myName + "uid": FirebaseAuth.instance.currentUser!.uid,
      userName + "uid": otherUseruid,
      userName + "newmessage": "false",
      Constants.myName + "newmessage": "true"
    };

    databaseMethods.addChatRoom(chatRoom, Constants.chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: Constants.chatRoomId,
                  otherusername: userName,
                  otheruid: otherUseruid!,
                )));
  }

  getChatRoomId(String a, String b) {
    print(a);
    print(b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    final images = [
      widget.item['image1'],
      widget.item['image2'],
      widget.item['image3'],
      widget.item['image4'],
    ];
    return Scaffold(
      backgroundColor: OurColor.kBackgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _controller,
            physics: _physics,
            child: Column(
              children: [
                Material(
                  color: OurColor.lightblack,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  elevation: 4,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      final image = images[index];
                      if (image != null) {
                        return Image.network(
                          image,
                          fit: BoxFit.contain,
                        );
                      } else {
                        return Container();
                      }
                    },
                    itemCount: images.length,
                    itemWidth: displayWidth,
                    itemHeight: displayHeight / 2,
                    layout: SwiperLayout.STACK,
                  ),

                ),
                const SizedBox(height: 15),
                Container(
                  width: displayWidth,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item["victim name"],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: OurColor.subTitleTextColor,
                              fontSize: 24,
                              fontFamily: 'Markazi text',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.item["victim Know blackmailer"],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: OurColor.subTitleTextColor,
                              fontSize: 18,
                              fontFamily: 'Markazi text',
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "الضحية",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: OurColor.titleTextColor,
                              fontSize: 24,
                              fontFamily: 'Markazi text',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "الضحية تعرف المبتز",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: OurColor.titleTextColor,
                              fontSize: 18,
                              fontFamily: 'Markazi text',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black38.withOpacity(0.2),
                  endIndent: 20,
                  indent: 20,
                  height: 4,
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffeaeaea),
                    radius: 26,
                    child: Icon(
                      FontAwesomeIcons.locationDot,
                      color: OurColor.lightblack,
                    ),
                  ),
                  title: Text(
                    widget.item["city"],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 15,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                ),
                ListTile(
                  isThreeLine: false,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffeaeaea),
                    radius: 26,
                    child: Icon(
                      FontAwesomeIcons.clock,
                      color: OurColor.lightblack,
                    ),
                  ),
                  title: Text(
                    "متى بدأ لإبتزاز",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 18,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                  subtitle: Text(
                    widget.item["when this start"],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 15,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                ),
                ListTile(
                  isThreeLine: false,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffeaeaea),
                    radius: 26,
                    child: Icon(
                      FontAwesomeIcons.person,
                      color: OurColor.lightblack,
                    ),
                  ),
                  title: Text(
                    "جنس الضحية",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 18,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                  subtitle: Text(
                    widget.item["victim sex"],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 15,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                ),
                ListTile(
                  isThreeLine: false,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffeaeaea),
                    radius: 26,
                    child: Icon(
                      Icons.family_restroom,
                      color: OurColor.lightblack,
                    ),
                  ),
                  title: Text(
                    "علاقتي بالضحية",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 18,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                  subtitle: Text(
                    widget.item["who are you to victim"],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: OurColor.titleTextColor,
                      fontSize: 15,
                      fontFamily: 'Markazi text',
                    ),
                  ),
                ),
                Container(
                  width: displayWidth,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "معلومات حول المبتز",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: OurColor.titleTextColor,
                              fontSize: 24,
                              fontFamily: 'Markazi text',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.item["blackmailer Info"],
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: OurColor.titleTextColor,
                              fontSize: 18,
                              fontFamily: 'Markazi text',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                )
              ],
            ),
          )),
          Container(
              margin: EdgeInsets.all(displayWidth * .05),
              height: displayWidth * .155,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: OurColor.lightblack,
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child: GestureDetector(
                onTap: () {
                  sendMessage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.message,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "تواصل مع الضحية",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Markazi text',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white,
                  child: const Icon(
                    FontAwesomeIcons.arrowDown,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 48,
                height: 48,
                color: Colors.white,
                child: const Icon(
                  FontAwesomeIcons.download,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 48,
                height: 48,
                color: Colors.white,
                child: const Icon(
                  FontAwesomeIcons.heart,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
