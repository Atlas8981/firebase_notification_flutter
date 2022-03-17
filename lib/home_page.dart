import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: (message),
    //   );
    // }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    NotificationSettings settings = await _fcm.requestPermission(
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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    setupInteractedMessage();
  }

  Future<void> saveDeviceToken() async {
    String? fcmToken = await _fcm.getToken();
    String uid = "auth.uid";
    if (fcmToken != null) {
      var tokenRef =
          _db.collection("users").doc(uid).collection('token').doc(fcmToken);
      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
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
            payload: "this is payload");
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
