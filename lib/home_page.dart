import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final fcm = FirebaseMessaging.instance;
  final functions = FirebaseFunctions.instance;
  final notificationService = NotificationService();

  Future<void> saveDeviceToken() async {
    String? fcmToken = await fcm.getToken();
    String uid = "auth.uid";
    if (fcmToken != null) {
      final tokenRef =
          db.collection("users").doc(uid).collection('token').doc(fcmToken);
      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // NotificationService.init();
    // notificationService.setupInteractedMessage();
    // notificationService.setUpOnMessage();
  }

  Future<void> callCloudFunction() async {
    print("calling");
    final HttpsCallable callable =
        functions.httpsCallable('sendHttpCallablePushNotification');
    try {
      final results = await callable();

      if (kDebugMode) {
        print("results: $results");
      }
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print(e.toString());
        print(e.message);
        print(e.code);
        print(e.details);
        print(e.stackTrace);
      }
    }
  }

  Future<void> getToken() async {
    final token = await fcm.getToken();
    print("Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Notification"),
        actions: [
          IconButton(
            onPressed: () {
              callCloudFunction();
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: Center(
        child: Text("Testing Notification"),
      ),
    );
  }
}
