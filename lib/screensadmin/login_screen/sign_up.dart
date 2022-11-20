import 'dart:async';

import 'package:Yemenaman/constants.dart';
import 'package:Yemenaman/screensadmin/login_screen/verify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Yemenaman/screensadmin/database.dart';
import 'package:Yemenaman/screensadmin/login_screen/sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../mainPage.dart';
import '../../widgets/auth.dart';
import '../../widgets/helperfunctions.dart';
import '../../widgets/title_text.dart';
import '../database.dart';

class sign_up extends StatefulWidget {
  final usertype;

  const sign_up({Key? key, this.usertype}) : super(key: key);
  @override
  _sign_upState createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final _formKeySignUp = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _btnController2.stop();
  }

  AuthService authService = new AuthService();

  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  singUp() async {
    if (_formKeySignUp.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(emailController.text.toLowerCase(),
              passwordController.text.toLowerCase())
          .then((result) async {
        if (result != null) {
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserNameSharedPreference(nameController.text);
          await HelperFunctions.saveUserEmailSharedPreference(emailController.text);

          Map<String, String> userDataMap = {
            "userName": nameController.text,
            "userEmail": emailController.text,
            "uid": FirebaseAuth.instance.currentUser!.uid,
            "status": "online",
          };

          await DatabaseMethods.addUserInfo1(userDataMap);
          await DatabaseMethods.addUserInfo2(userDataMap);


              FirebaseFirestore.instance
                  .collection("users1")
                  .where("userEmail", isEqualTo: emailController1.text)
                  .get()
                  .then((querySnapshot) {
                querySnapshot.docs.forEach((documentSnapshot) async{
                  print(
                      "--------------------------------------------------------------------------");
                  print(documentSnapshot.data()["userNfame"]);
                  Constants.myName = await documentSnapshot.data()["userName"];
                  Constants.myEmail = await documentSnapshot.data()["userEmail"];
                  ;
                });
              });
          setState(() {
            isLoading = false;
          });
          if (isLoading = false) {
            _btnController2.stop();
          }
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => VerifyPage()));
        }
      });
    } else {
      _btnController2.reset();
    }
  }

  signupbutton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: RoundedLoadingButton(
        color: Colors.greenAccent,
        successColor: Colors.amber,
        child: Text(
          "تأكيد".toUpperCase(),
          style: TextStyle(
              color: OurColor.kPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        controller: _btnController2,
        onPressed: () async {
          singUp();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: TitleText(
                          text: "إنشاء حساب جديد",
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: OurColor.subTitleTextColor),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKeySignUp,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      controller: nameController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: OurColor.subTitleTextColor, width: 2)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: OurColor.titleTextColor,
                        ),
                        hintText: ' الاسم',
                      ),
                      validator: (value) {
                        if (value == "support") {
                          return 'الرجاء كتابة اسم اخر';
                        }
                        if (value!.isEmpty) {
                          return 'الرجاء كتابة الاسم';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      controller: emailController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: OurColor.subTitleTextColor, width: 2)),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: OurColor.subTitleTextColor,
                        ),
                        hintText: 'البريد الإلكتروني',
                      ),
                      validator: (val) {
                        if (val == "support@yemenaman.com") {
                          return 'الرجاء كتابة بريد اخر';
                        }
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
                      textAlign: TextAlign.end,
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: OurColor.subTitleTextColor, width: 2)),
                        prefixIcon:
                            Icon(Icons.lock, color: OurColor.subTitleTextColor),
                        hintText: 'كلمة المرور',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء كتابة كلمة المرور';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  signupbutton(),
                  SizedBox(
                    height: 15,
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
                                  builder: (context) => sign_in(),
                                ));
                          },
                          child: TitleText(
                              text: "قم بتسجيل الدخول",
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TitleText(
                            text: "لدي حساب؟",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: OurColor.titleTextColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
