import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final localNotifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await localNotifications.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  static Future init({bool initScheduled = false}) async {
    const androidSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSetting = IOSInitializationSettings();

    const settings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );
    await localNotifications.initialize(
      settings,
      onSelectNotification: (payload) {
        // if(payload!=null){
        onNotifications.add(payload!);
        // }
      },
    );
  }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        channelShowBadge: true,
        priority: Priority.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      _handleMessageOnOpenApp(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOnOpenApp);
  }

  void setUpOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showNotification(
        title: '${message.notification!.title}',
        body: "${message.notification!.body}",
        payload: "this is payload",
      );
    });
  }

  void _handleMessageOnOpenApp(RemoteMessage message) {
    if (kDebugMode) {
      print(message.toString());
      print(message.messageId);
    }
  }
}
