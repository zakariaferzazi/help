import 'package:Yemenaman/constants.dart';
import 'package:Yemenaman/screensadmin/about_us.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Yemenaman/screensadmin/login_screen/sign_in.dart';
import 'package:Yemenaman/screensadmin/login_screen/sign_up.dart';

import '../../widgets/title_text.dart';

class welcomepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _welcomepageState();
  }
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _welcomepageState extends State<welcomepage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
  
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false, 

        backgroundColor: OurColor.kPrimaryColor,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  
                  child: Center(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: MediaQuery.of(context).size.height * .30,
                            margin: EdgeInsets.all(5),
                            child: Image.asset("assets/images/logosignin.png"))),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TitleText(
                        text: "تحتاج للمساعدة؟",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: OurColor.titleTextColor),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TitleText(
                        text: "أنت في المكان الصحيح",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: OurColor.subTitleTextColor),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sign_in(),
                        ));
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.only(right: 40, left: 40),
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              offset: Offset(0, 15)),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.greenAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(FontAwesomeIcons.signIn,color: Colors.white,),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sign_up(),
                        ));
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.only(right: 40, left: 40),
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              offset: Offset(0, 15)),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.greenAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.create,color: Colors.white,),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => about_us(),
                        ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: TitleText(
                        text: "من نحن؟",
                        fontSize: 25,
                        color: OurColor.subTitleTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
