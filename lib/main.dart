import 'dart:async';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/screen/home_page.dart';
import 'package:woocommerce_app/screen/splash_screen_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:woocommerce_app/screen/onboard_screen.dart';
import 'package:woocommerce_app/screen/onboard_screen.dart';
import 'package:woocommerce_app/screen/login_page.dart';

/* firebase */
import 'package:firebase_core/firebase_core.dart';
import 'package:woocommerce_app/firebase_api.dart';
/* import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart'; */

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(new MyApp());
}
//void main() => runApp(new MyApp());
/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // TODO: Request permission

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  print(settings);

  // TODO: Register with FCM
  // TODO: Set up foreground message handler
  // TODO: Set up background message handler

  runApp(MyApp());
}
*/

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String userId = '';
  late String username= '';
  bool isLoading = true;

  void initState() {
    super.initState();

    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
        print("userId");
        print(userId);

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if (userId != 'Unknown') {
      // Show a loading indicator while data is being fetched
      return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dr.Bilel Guiga',
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
         //home: OnboardingScreen(),
        home: HomePage(),

        //home: OnboardingScreen(),
      );
    } else {
      return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dr.Bilel Guiga',
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        //home: HomePage(),
        home: OnboardingScreen(),
        //home: SplashScreen(),
      );
    }
  }

  Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    //return await storage.readAll();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
      'email': await storage.read(key: 'email'),
      // Add other pieces of user information as needed
    };
  }
  Future<void> clearUserInformation(BuildContext context) async {
    final storage = FlutterSecureStorage();

    // Delete stored values
    await storage.delete(key: 'userId');
    await storage.delete(key: 'username');
    await storage.delete(key: 'email');
    await storage.delete(key: 'phone');
    await storage.delete(key: 'first_name');
    await storage.delete(key: 'last_name');
    await storage.delete(key: 'billing_naissance');
    await storage.delete(key: 'billing_sexe');
    await storage.delete(key: 'role');

    // Add more keys if needed

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

