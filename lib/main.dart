import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification/home_page.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelGroupKey: 'basic_tests',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        criticalAlerts: true,
        enableVibration: true,
        defaultPrivacy: NotificationPrivacy.Public,
        playSound: true,
      ),
      NotificationChannel(
        channelGroupKey: 'basic_tests',
        channelKey: 'badge_channel',
        channelName: 'Badge indicator notifications',
        channelDescription: 'Notification channel to activate badge indicator',
        channelShowBadge: true,
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.yellow,
      ),
      NotificationChannel(
        channelGroupKey: 'category_tests',
        channelKey: 'call_channel',
        channelName: 'Calls Channel',
        channelDescription: 'Channel with call ringtone',
        defaultColor: Color(0xFF9D50DD),
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      ),
      NotificationChannel(
        channelGroupKey: 'category_tests',
        channelKey: 'alarm_channel',
        channelName: 'Alarms Channel',
        channelDescription: 'Channel with alarm ringtone',
        defaultColor: Color(0xFF9D50DD),
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
      ),
      NotificationChannel(
        channelGroupKey: 'channel_tests',
        channelKey: 'updated_channel',
        channelName: 'Channel to update',
        channelDescription: 'Notifications with not updated channel',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
      NotificationChannel(
        channelGroupKey: 'chat_tests',
        channelKey: 'chats',
        channelName: 'Chat groups',
        channelDescription: 'This is a simple example channel of a chat group',
        channelShowBadge: true,
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
        defaultColor: Color(0xFF9D50DD),
      ),
      NotificationChannel(
        channelGroupKey: 'vibration_tests',
        channelKey: 'low_intensity',
        channelName: 'Low intensity notifications',
        channelDescription:
            'Notification channel for notifications with low intensity',
        defaultColor: Colors.green,
        ledColor: Colors.green,
        vibrationPattern: lowVibrationPattern,
      ),
      NotificationChannel(
        channelGroupKey: 'vibration_tests',
        channelKey: 'medium_intensity',
        channelName: 'Medium intensity notifications',
        channelDescription:
            'Notification channel for notifications with medium intensity',
        defaultColor: Colors.yellow,
        ledColor: Colors.yellow,
        vibrationPattern: mediumVibrationPattern,
      ),
      NotificationChannel(
        channelGroupKey: 'vibration_tests',
        channelKey: 'high_intensity',
        channelName: 'High intensity notifications',
        channelDescription:
            'Notification channel for notifications with high intensity',
        defaultColor: Colors.red,
        ledColor: Colors.red,
        vibrationPattern: highVibrationPattern,
      ),
      NotificationChannel(
        channelGroupKey: 'privacy_tests',
        channelKey: "private_channel",
        channelName: "Privates notification channel",
        channelDescription: "Privates notification from lock screen",
        playSound: true,
        defaultColor: Colors.red,
        ledColor: Colors.red,
        vibrationPattern: lowVibrationPattern,
        defaultPrivacy: NotificationPrivacy.Private,
      ),
      // NotificationChannel(
      //   channelGroupKey: 'sound_tests',
      //   icon: 'resource://drawable/res_power_ranger_thunder',
      //   channelKey: "custom_sound",
      //   channelName: "Custom sound notifications",
      //   channelDescription: "Notifications with custom sound",
      //   playSound: true,
      //   soundSource: 'resource://raw/res_morph_power_rangers',
      //   defaultColor: Colors.red,
      //   ledColor: Colors.red,
      //   vibrationPattern: lowVibrationPattern,
      // ),
      NotificationChannel(
        channelGroupKey: 'sound_tests',
        channelKey: "silenced",
        channelName: "Silenced notifications",
        channelDescription: "The most quiet notifications",
        playSound: false,
        enableVibration: false,
        enableLights: false,
      ),
      // NotificationChannel(
      //     channelGroupKey: 'media_player_tests',
      //     icon: 'resource://drawable/res_media_icon',
      //     channelKey: 'media_player',
      //     channelName: 'Media player controller',
      //     channelDescription: 'Media player controller',
      //     defaultPrivacy: NotificationPrivacy.Public,
      //     enableVibration: false,
      //     enableLights: false,
      //     playSound: false,
      //     locked: true),
      NotificationChannel(
        channelGroupKey: 'image_tests',
        channelKey: 'big_picture',
        channelName: 'Big pictures',
        channelDescription: 'Notifications with big and beautiful images',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Color(0xFF9D50DD),
        vibrationPattern: lowVibrationPattern,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
          channelGroupKey: 'layout_tests',
          channelKey: 'big_text',
          channelName: 'Big text notifications',
          channelDescription: 'Notifications with a expandable body text',
          defaultColor: Colors.blueGrey,
          ledColor: Colors.blueGrey,
          vibrationPattern: lowVibrationPattern),
      NotificationChannel(
          channelGroupKey: 'layout_tests',
          channelKey: 'inbox',
          channelName: 'Inbox notifications',
          channelDescription: 'Notifications with inbox layout',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: mediumVibrationPattern),
      NotificationChannel(
        channelGroupKey: 'schedule_tests',
        channelKey: 'scheduled',
        channelName: 'Scheduled notifications',
        channelDescription: 'Notifications with schedule functionality',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Color(0xFF9D50DD),
        vibrationPattern: lowVibrationPattern,
        importance: NotificationImportance.High,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        criticalAlerts: true,
      ),
      // NotificationChannel(
      //     channelGroupKey: 'layout_tests',
      //     icon: 'resource://drawable/res_download_icon',
      //     channelKey: 'progress_bar',
      //     channelName: 'Progress bar notifications',
      //     channelDescription: 'Notifications with a progress bar layout',
      //     defaultColor: Colors.deepPurple,
      //     ledColor: Colors.deepPurple,
      //     vibrationPattern: lowVibrationPattern,
      //     onlyAlertOnce: true),
      NotificationChannel(
          channelGroupKey: 'grouping_tests',
          channelKey: 'grouped',
          channelName: 'Grouped notifications',
          channelDescription: 'Notifications with group functionality',
          groupKey: 'grouped',
          groupSort: GroupSort.Desc,
          groupAlertBehavior: GroupAlertBehavior.Children,
          defaultColor: Colors.lightGreen,
          ledColor: Colors.lightGreen,
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High)
    ],
    channelGroups: [
      // NotificationChannelGroup(
      //   channelGroupkey: 'basic_tests',
      //   channelGroupName: 'Basic tests',
      // ),
      // NotificationChannelGroup(
      //     channelGroupkey: 'category_tests',
      //     channelGroupName: 'Category tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'image_tests', channelGroupName: 'Images tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'schedule_tests',
      //     channelGroupName: 'Schedule tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'chat_tests', channelGroupName: 'Chat tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'channel_tests', channelGroupName: 'Channel tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'sound_tests', channelGroupName: 'Sound tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'vibration_tests',
      //     channelGroupName: 'Vibration tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'privacy_tests', channelGroupName: 'Privacy tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'layout_tests', channelGroupName: 'Layout tests'),
      // NotificationChannelGroup(
      //     channelGroupkey: 'grouping_tests',
      //     channelGroupName: 'Grouping tests'),
    ],
    debug: false,
  );
  await Firebase.initializeApp();
  FirebaseFunctions.instance.useFunctionsEmulator(
    'localhost',
    5001,
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');

  if (!AwesomeStringUtils.isNullOrEmpty(
        message.notification?.title,
        considerWhiteSpaceAsEmpty: true,
      ) ||
      !AwesomeStringUtils.isNullOrEmpty(
        message.notification?.body,
        considerWhiteSpaceAsEmpty: true,
      )) {
    print('message also contained a notification: ${message.notification}');

    String? imageUrl;
    imageUrl ??= message.notification!.android?.imageUrl;
    imageUrl ??= message.notification!.apple?.imageUrl;

    Map<String, dynamic> notificationAdapter = {
      NOTIFICATION_CHANNEL_KEY: 'basic_channel',
      NOTIFICATION_ID: message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
          message.messageId ??
          Random().nextInt(2147483647),
      NOTIFICATION_TITLE: message.data[NOTIFICATION_CONTENT]
              ?[NOTIFICATION_TITLE] ??
          message.notification?.title,
      NOTIFICATION_BODY: message.data[NOTIFICATION_CONTENT]
              ?[NOTIFICATION_BODY] ??
          message.notification?.body,
      NOTIFICATION_LAYOUT:
          AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
      NOTIFICATION_BIG_PICTURE: imageUrl,
    };
    AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
  } else {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing Firebase Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
