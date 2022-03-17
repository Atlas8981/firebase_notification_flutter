
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final  notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,}) async {
    // final AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings();
    // final MacOSInitializationSettings initializationSettingsMacOS =
    // MacOSInitializationSettings();
    // final InitializationSettings initializationSettings = InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsIOS,
    // );
    // await notifications.initialize(initializationSettings,);
    notifications.show(id, title, body, await notificationDetails(),
        payload: payload);

    onNotifications.stream.listen((payload) {

    });
  }
  static Future init({bool initScheduled = false}) async {
    const androidSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSetting = IOSInitializationSettings();

    const settings = InitializationSettings(android: androidSetting,iOS: iosSetting);
    await notifications.initialize(
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
          importance: Importance.high,
        ),
        iOS: IOSNotificationDetails());
  }
}
