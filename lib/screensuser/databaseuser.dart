import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';





class DatabaseMethods {
  static Future<void> addUserInfo1(userData) async {
    FirebaseFirestore.instance.collection("users").doc( FirebaseAuth.instance.currentUser!.uid).collection(FirebaseAuth.instance.currentUser!.uid).add(userData).catchError((e) {
      print(e.toString());
    });
  }
  static Future<void> addUserInfo2(userData) async {
    FirebaseFirestore.instance.collection("users1").add(userData).catchError((e) {
      print(e.toString());
    });
  }
  

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users1")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) async {
    return FirebaseFirestore.instance
        .collection("users1")
        .where('userName', isEqualTo: searchField.toLowerCase())
        .get();
  }

  Future<bool>? addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData)async{

    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}
