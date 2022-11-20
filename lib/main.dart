import 'package:Yemenaman/screensuser/postsuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Yemenaman/mainPage.dart';
import 'package:Yemenaman/screensadmin/login_screen/welcome%20page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'screensadmin/login_screen/sign_in.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => posts(),
  //                 ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  const AndroidInitializationSettings('@mipmap/ic_notification');
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



  if(FirebaseAuth.instance.currentUser != null){
  if (FirebaseAuth.instance.currentUser?.emailVerified != false){
    if(Constants.myEmail=="support@yemenaman.com"){
    runApp(const MyAppSupport());
    }else{
    runApp(const MyAppUser());
    }

  } else {
    runApp(const MyApp());
  }
  }else{
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(
        navigateRoute: welcomepage(),
        duration: 3000,
        imageSize: 600,
        imageSrc: "assets/images/splach.png",
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyAppUser extends StatelessWidget {
  const MyAppUser({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(
        navigateRoute: postsuser(),
        duration: 3000,
        imageSize: 600,
        imageSrc: "assets/images/splach.png",
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyAppSupport extends StatelessWidget {
  const MyAppSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(
        navigateRoute: MainPage(),
        duration: 3000,
        imageSize: 600,
        imageSrc: "assets/images/splach.png",
        backgroundColor: Colors.white,
      ),
    );
  }
}
