
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'chat.dart';
import 'chatrooms.dart';
import 'database.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  int _selectedIndex = 1;
  bool isLoading = false;
  bool haveUserSearched = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? otherUseruid;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot!.docs.length,
            itemBuilder: (context, index) {
              otherUseruid = searchResultSnapshot!.docs[index]["uid"];
              return userTile(
                  searchResultSnapshot!.docs[index]["userName"],
                  searchResultSnapshot!.docs[index]["userEmail"],
                  searchResultSnapshot!.docs[index]["uid"]);
            })
        : Container();
  }

  otheruseruid() async {
    var uid;
    return await haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return uid = searchResultSnapshot!.docs[index]["uid"];
            })
        : Container();
  }



  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName) async {
    List<String> users = [Constants.myName, userName];

    Constants.chatRoomId = getChatRoomId(Constants.myName, userName);

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

  Widget userTile(String userName, String userEmail, String uid) {
    Future<String> getPicurl() async {
      Reference ref =
          FirebaseStorage.instance.ref().child("images/${uid}");
      var url = (await ref.getDownloadURL());
      return url;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          ClipOval(
              child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: (getPicurl() != null)
                ? FutureBuilder<String>(
                    future: getPicurl(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(
                          snapshot.toString(),
                          fit: BoxFit.cover,
                        );
                      }
                      return CircularProgressIndicator(
                        color: Colors.orange,
                      );
                    })
                : Image.network(
                    "https://www.shareicon.net/data/2016/05/26/771198_man_512x512.png",
                    fit: BoxFit.contain,
                  ),
          )),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.amber, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.amber, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Future<String> getPicurl() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.uid}");
    var url = (await ref.getDownloadURL());
    return url;
  }

  navigationTapped(int page) {
    if (page == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    }
    // if (page == 1) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => Search()));
    // }
    // if (page == 2) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => ProfilePage()));
    // } 
    else {
      setState(() {
        _selectedIndex = page;
      });
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        navigationTapped(value);
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(
          icon: ClipOval(
            child: SizedBox(
              height: 40,
              width: 40,
              child: (getPicurl() != null)
                  ? FutureBuilder<String>(
                      future: getPicurl(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(
                            snapshot.toString(),
                            fit: BoxFit.cover,
                          );
                        }
                        return CircularProgressIndicator(
                          color: Color.fromARGB(255, 167, 100, 0),
                        );
                      })
                  : Image.network(
                      "https://www.shareicon.net/data/2016/05/26/771198_man_512x512.png",
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      appBar: AppBar(backgroundColor: Colors.green,),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Colors.amber,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: TextStyle(color: Colors.white,fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "search username ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.green,
                                        Colors.amber
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Image.asset(
                                "assets/images/search_white.png",
                                height: 25,
                                width: 25,
                              )),
                        )
                      ],
                    ),
                  ),
                  userList(),
                ],
              ),
            ),
    );
  }
}
