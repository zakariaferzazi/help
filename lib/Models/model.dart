import 'dart:ui';
import 'package:Yemenaman/constants.dart';
import 'package:Yemenaman/screensadmin/home&details/blackmailpostdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screensadmin/chatrooms.dart';
import '../screensadmin/home&details/details.dart';
import 'model_items.dart';

class ModelBlacmailposts extends StatefulWidget {
  final double padding = 24.0;
  final double spacing = 10.0;

  @override
  State<ModelBlacmailposts> createState() => _ModelBlacmailpostsState();
}

class _ModelBlacmailpostsState extends State<ModelBlacmailposts> {
  late final ScrollController _scrollController;
  late final double _indexFactor;
  static const _imageWidth = 180.0;
  double _imageOffset = 0.0;

  @override
  void initState() {
    final deviceWidth =
        (window.physicalSize.shortestSide / window.devicePixelRatio);
    _indexFactor = (widget.spacing + _imageWidth) / deviceWidth;
    _imageOffset = -widget.padding / deviceWidth;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _imageOffset =
            ((_scrollController.offset - widget.padding) / deviceWidth);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 240,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("blackmailingposts")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: widget.padding),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlackMailPostdetails(
                                item: snapshot.data!.docs[index],)),
                      );
                    },
                    child: SizedBox(
                      height: 240,
                      width: 200,
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
                                  imageWidth: _imageWidth,
                                  imageOffset: _imageOffset,
                                  indexFactor: _indexFactor,
                                  hero: snapshot.data!.docs[index]["image1"] ??
                                      snapshot.data!.docs[index]["image2"] ??
                                      snapshot.data!.docs[index]["image3"] ??
                                      snapshot.data!.docs[index]["image4"] ??
                                      "https://www.tarshi.net/inplainspeak/wp-content/uploads/2017/01/1-1.jpg",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                // color: Colors.green,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 15, bottom: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]["victim name"],
                                      style: const TextStyle(
                                        color: OurColor.titleTextColor,
                                        fontSize: 22,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          color:
                                              Colors.grey.withOpacity(0.5),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          snapshot.data!.docs[index]["city"],
                                          style: TextStyle(
                                            color: OurColor.subTitleTextColor
                                                .withOpacity(0.5),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}

class Modelposts extends StatefulWidget {
  final double padding = 24.0;
  final double spacing = 10.0;

  @override
  State<Modelposts> createState() => _ModelpostsState();
}

class _ModelpostsState extends State<Modelposts> {
  late final ScrollController _scrollController;
  late final double _indexFactor;

  static const _imageWidth = 270.0;
  double _imageOffset = 0.0;

  @override
  void initState() {
    final deviceWidth =
        (window.physicalSize.shortestSide / window.devicePixelRatio);
    _indexFactor = (widget.spacing + _imageWidth) / deviceWidth;
    _imageOffset = -widget.padding / deviceWidth;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _imageOffset =
            ((_scrollController.offset - widget.padding) / deviceWidth);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 240,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: widget.padding),
                scrollDirection: Axis.horizontal,
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
                        elevation: 3,
                        color: OurColor.kPrimaryColor,
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
                                    imageWidth: _imageWidth,
                                    imageOffset: _imageOffset,
                                    indexFactor: _indexFactor,
                                    hero: snapshot.data!.docs[index]["image"]),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(snapshot.data!.docs[index]["title"],
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.getFont(
                                      'Markazi Text',
                                      color: Colors.grey,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
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
                                    color: Colors.grey,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
