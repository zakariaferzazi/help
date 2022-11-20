
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Yemenaman/widgets/user.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Usere? _userFromFirebaseUser(User user) {
    return user != null ? Usere(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password, RoundedLoadingButtonController _btnController, BuildContext context) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }  on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          _btnController.reset();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("المستخدم ليس موجود")));
        }
        if (e.code == "wrong-password") {
          _btnController.reset();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("كلمة مرور خاطئة")));
        }
        if (e.code == "invalid-email") {
          _btnController.reset();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("بريد إلكتروني خاطئ")));
        }
      }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }





}
