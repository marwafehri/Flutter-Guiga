import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    // Token: cYiYrBR-TRqFKX9jF_35VU:APA91bGVlNv0LU5sXdL6-xjTAjKslh1DBiMnpLapZo8BBAcITSHB1mw92vXNwzCbWaUSn97WfDn6yaOkCmh4gQVsAW6nibaDJ3c1n7hAWXT2COB3aVYrGofN1S0ysoibr-zj0si18Y78
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}