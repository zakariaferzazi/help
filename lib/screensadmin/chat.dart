import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import 'database.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String otheruid;
  final String otherusername;

  Chat({
    required this.chatRoomId,
    required this.otheruid,
    required this.otherusername,
  });

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  File? image;
  bool imageuploaded = false;
  File? imageTemp;
  String? imagePath;
  final RoundedLoadingButtonController _btnControllerimage =
      RoundedLoadingButtonController();

  File? video;
  bool videouploaded = false;
  File? videoTemp;
  String? videoPath;
  final RoundedLoadingButtonController _btnControllervideo =
      RoundedLoadingButtonController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data!.docs.reversed.toList()[index]
                          ["message"],
                      time: snapshot.data!.docs.reversed.toList()[index]
                          ["time"],
                      sendByMe: Constants.myName ==
                          snapshot.data!.docs.reversed.toList()[index]
                              ["sendBy"],
                      type: snapshot.data!.docs.reversed.toList()[index]
                          ["type"]);
                })
            : Container();
      },
    );
  }

  // image proceesssssss

  Future pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final galleryimage = await _picker.pickImage(source: ImageSource.gallery);

      if (galleryimage == null) return;
      imageTemp = File(galleryimage.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  UploadImage() async {
    imagePath =
        "chatimages/${widget.chatRoomId}/${Constants.myName}/${imageTemp.toString()}";
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(imagePath!);
    UploadTask uploadTask = ref.putFile(image!);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    TaskSnapshot taskSnapshot = await uploadTask;
  }

  Future<String> getchatimage() async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath!);
    var url = (await ref.getDownloadURL());
    print(url);
    return url;
  }

  addimagemessage() async {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": await getchatimage(),
      'time': DateTime.now(),
      "type": "image"
    };
    await DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
    _btnControllerimage.success();
  }

  // video proceesssssss

  Future pickvideo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final galleryvideo = await _picker.pickVideo(source: ImageSource.gallery);
      if (galleryvideo == null) return;
      videoTemp = File(galleryvideo.path);
      setState(() => this.video = videoTemp);
    } on PlatformException catch (e) {
      print('Failed to pick video: $e');
    }
  }

  Uploadvideo() async {
    videoPath =
        "chatvideo/${widget.chatRoomId}/${Constants.myName}/${Random().nextInt(100)}";
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(videoPath!);
    UploadTask uploadTask = ref.putFile(video!);
    var videoUrl = await (await uploadTask).ref.getDownloadURL();
    TaskSnapshot taskSnapshot = await uploadTask;
  }

  Future<String> getchatvideo() async {
    Reference ref = FirebaseStorage.instance.ref().child(videoPath!);
    var urlvideo = (await ref.getDownloadURL());
    print(urlvideo);
    return urlvideo;
  }

  addvideomessage() async {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": await getchatvideo(),
      'time': DateTime.now(),
      "type": "video"
    };
    await DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
    _btnControllerimage.success();
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .where(widget.chatRoomId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference
              .update({Constants.myName + "newmessage": "true"});
        });
      });
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now(),
        "type": "text"
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    _btnControllerimage.stop();
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: OurColor.kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          ClipOval(
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
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.otherusername,
                style: TextStyle(fontSize: 17),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.circle_notifications),
          iconSize: 35,
          onPressed: () {},
        ),
        SizedBox(width: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String messageText;
    bool isuploded = true;
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        color: OurColor.kBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: chatMessages(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                color: Color.fromARGB(255, 207, 204, 204),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await pickImage();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.green,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: (image != null)
                                              ? Image.file(image!,
                                                  fit: BoxFit.cover)
                                              : Image.network(
                                                  "https://www.shareicon.net/data/2016/05/26/771198_man_512x512.png",
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    color: Colors.transparent,
                                    child: RoundedLoadingButton(
                                        color: Colors.amber,
                                        successColor: Colors.green,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Send",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Icon(Icons.send,
                                                color: Colors.white)
                                          ],
                                        ),
                                        controller: _btnControllerimage,
                                        onPressed: () async {
                                          await UploadImage();
                                          await addimagemessage();
                                          Navigator.pop(context);
                                        })),
                              ]));
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.image,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await pickvideo();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.transparent,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: Image.asset("assets/images/success.png",
                                                  fit: BoxFit.cover)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    color: Colors.transparent,
                                    child: RoundedLoadingButton(
                                        color: Colors.amber,
                                        successColor: Colors.green,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Send",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Icon(Icons.send,
                                                color: Colors.white)
                                          ],
                                        ),
                                        controller: _btnControllerimage,
                                        onPressed: () async {
                                          await Uploadvideo();
                                          await addvideomessage();
                                          Navigator.pop(context);
                                        })),
                              ]));
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.video_camera_back,
                          color: Colors.green,
                          size: 35,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20 * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20 / 4),
                            Expanded(
                              child: TextField(
                                controller: messageEditingController,
                                decoration: InputDecoration(
                                  hintText: "Type message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: 20 / 3),
                            InkWell(
                              onTap: () {
                                addMessage();
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class MessageTile extends StatefulWidget {
  final String message;
  final bool sendByMe;
  final Timestamp time;
  final String type;

  MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.time,
      required this.type});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  VideoPlayerController? _controller;

  Future<void>? _initializeVideoPlayerFuture;

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.message);
    _initializeVideoPlayerFuture = _controller!.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.Hm().format(widget.time.toDate());

    messagetype(String messagerandom) {
      if (widget.type == "image") {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(23.0),
              child: Image.network(
                messagerandom,
                fit: BoxFit.cover,
              )),
        );
      }
      if (widget.type == "text") {
        return Text(messagerandom,
            textAlign: TextAlign.end,
            style: TextStyle(
              
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300));
      }
      if (widget.type == "video") {
        return Column(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(23.0),
              child: VideoPlayer(_controller!),),
        )
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Center(
              child: InkWell(
              onTap: () {
          setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
          });
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(50)),
          child: Icon(
            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 80,
          ),
        ),
          ),
            )
          ],
        );
      }
    }

    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: widget.sendByMe ? 0 : 10,
          right: widget.sendByMe ? 10 : 0),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: widget.sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23))
                : BorderRadius.only(
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: widget.sendByMe
                  ? [Colors.green, Colors.green]
                  : [Colors.amber, Colors.amber],
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(child: messagetype(widget.message)),
            Container(
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}











