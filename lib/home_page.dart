import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late StreamSubscription iosSubscription;

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.toString());
    print(message.messageId);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    setupInteractedMessage();
  }

  Future<void> saveDeviceToken() async {
    String? fcmToken = await _fcm.getToken();
    String uid = "auth.uid";
    if (fcmToken != null) {
      final tokenRef =
          _db.collection("users").doc(uid).collection('token').doc(fcmToken);
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
    if (Platform.isIOS) {
      // iosSubscription = _fcm.requestPermission();
      // _fcm.requestPermission(());
    } else {
      saveDeviceToken();
    }

    NotificationService.init();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null &&
          message.notification!.android != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print(message.notification!.title);
        NotificationService.showNotification(
          title: '${message.notification!.title}',
          body: "${message.notification!.body}",
          payload: "this is payload",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Notification"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendNotification();
        },
        child: const Icon(Icons.message),
      ),
    );
  }

  //Using cloud function to send notification
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  void sendNotification() {
    callCloudFunction();
  }

  Future<void> callCloudFunction() async {
    final HttpsCallable callable =
        functions.httpsCallable('sendHttpCallablePushNotification');
    callable.call('Something is here');
    try {
      final results = await callable();
      print(results);
    } on FirebaseFunctionsException catch (e) {
      print(e.message);
      print(e.code);
    }
  }
}
