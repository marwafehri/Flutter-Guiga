import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:woocommerce_app/screen/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/screen/forget-login_page.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();

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

    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _isHomePageReady;

  @override
  void initState() {
    super.initState();
    _isHomePageReady = false;
    prepareHomePage().then((_) {
      setState(() {
        _isHomePageReady = true;
      });
      navigateToHome();
    });
  }
  Future<void> prepareHomePage() async {
    // Simulate some initialization process
    await Future.delayed(Duration(seconds: 2));  // Replace with actual initialization logic
    // Ensure HomePage is ready to be displayed
    // For example, load necessary resources
  }

  void navigateToHome() {
    if (mounted && _isHomePageReady) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFFe8e0d7)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/logo.png'),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Text(
                        'Dr.Bilel Guiga',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   // CircularProgressIndicator(backgroundColor: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "chirurgien Maxillofacial,\n & esthétique en Tunisie",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black),
                    )
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }

}
