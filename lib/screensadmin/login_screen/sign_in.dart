import 'dart:async';

import 'package:Yemenaman/constants.dart';
import 'package:Yemenaman/screensadmin/login_screen/welcome%20page.dart';
import 'package:Yemenaman/screensuser/postsuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Yemenaman/screensadmin/login_screen/sign_up.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../mainPage.dart';
import '../../widgets/auth.dart';
import '../../widgets/helperfunctions.dart';
import '../../widgets/title_text.dart';
import '../database.dart';

class sign_in extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _sign_inState();
  }
}

final _formKeySignIn = GlobalKey<FormState>();

TextEditingController emailController1 = TextEditingController();
TextEditingController passwordController1 = TextEditingController();

class _sign_inState extends State<sign_in> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    emailController1.clear();
    passwordController1.clear();
    _btnController.stop();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    AuthService authService = new AuthService();

    bool isLoading = false;

    signIn() async {
      try {
        if (_formKeySignIn.currentState!.validate()) {
          await authService
              .signInWithEmailAndPassword(emailController1.text,
                  passwordController1.text, _btnController, context)
              .then((result) async {
            if (result != null) {
              QuerySnapshot userInfoSnapshot =
                  await DatabaseMethods().getUserInfo(emailController1.text);
              await HelperFunctions.saveUserLoggedInSharedPreference(true);
              await HelperFunctions.saveUserNameSharedPreference(
                  userInfoSnapshot.docs[0]["userName"]);
              await HelperFunctions.saveUserEmailSharedPreference(
                  userInfoSnapshot.docs[0]["userEmail"]);
              await FirebaseFirestore.instance
                  .collection("users1")
                  .where("uid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((querySnapshot) {
                querySnapshot.docs.forEach((documentSnapshot) {
                  documentSnapshot.reference.update({"status": "online"});
                });
              });
              FirebaseFirestore.instance
                  .collection("users1")
                  .where("userEmail", isEqualTo: emailController1.text)
                  .get()
                  .then((querySnapshot) {
                querySnapshot.docs.forEach((documentSnapshot) {
                  print(
                      "--------------------------------------------------------------------------");
                  print(documentSnapshot.data()["userName"]);
                  Constants.myName = documentSnapshot.data()["userName"];
                  Constants.myEmail = documentSnapshot.data()["userEmail"];
                  if (documentSnapshot.data()["userName"] == "support") {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainPage()));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => postsuser()));
                  }

                  ;
                });
              });
            } else {
              _btnController.reset();
            }
          });
        } else {
          _btnController.reset();
        }
      } on FirebaseAuthException catch (e) {
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

    signinbutton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: RoundedLoadingButton(
          color: Colors.greenAccent,
          successColor: Colors.amber,
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(
                color: OurColor.kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          controller: _btnController,
          onPressed: () async {
            signIn();
            _btnController.reset();
            if (isLoading = false) {
              _btnController.stop();
            }
          },
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: OurColor.kPrimaryColor,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: MediaQuery.of(context).size.height * .20,
                          margin: EdgeInsets.all(5),
                          child: Image.asset("assets/images/logosignin.png"))),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TitleText(
                          text: "فريق محاربة لإبتزاز الألكتروني",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: OurColor.titleTextColor),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TitleText(
                          text: 'تسجيل الدخول',
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: OurColor.subTitleTextColor),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKeySignIn,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      controller: emailController1,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: OurColor.subTitleTextColor, width: 2)),
                        prefixIcon:
                            Icon(Icons.mail, color: OurColor.subTitleTextColor),
                        hintText: 'البريد الإلكتروني',
                      ),
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : 'الرجاء كتابة البريد الإلكتروني';
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextFormField(
                      cursorColor: OurColor.subTitleTextColor,
                      obscureText: true,
                      textAlign: TextAlign.end,
                      controller: passwordController1,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: OurColor.subTitleTextColor,
                          width: 2,
                        )),
                        prefixIcon:
                            Icon(Icons.lock, color: OurColor.subTitleTextColor),
                        hintText: 'كلمة المرور',
                      ),
                      validator: (val) {
                        return val!.length > 6
                            ? null
                            : 'الرجاء كتابة كلمة المرور';
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, right: 32, bottom: 32),
                        child: InkWell(
                          onTap: (() async {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: emailController1.text);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "يرجى التحقق من البريد الوارد الخاص بك")));
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.code)));
                            }
                          }),
                          child: TitleText(
                              text: 'هل نسيت كلمة السر ؟',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: OurColor.subTitleTextColor),
                        )),
                  ),
                  signinbutton()
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => sign_up(),
                          ));
                    },
                    child: TitleText(
                        text: "قم بإنشاء حساب",
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TitleText(
                      text: "ليس لديك حساب؟",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: OurColor.subTitleTextColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
