import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool isInitialized = false;

  Future<void> InitNotification() async {
    if (isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    const initSettings = InitializationSettings(android: initSettingsAndroid);

    await notificationsPlugin.initialize(initSettings);
  }

  AndroidNotificationDetails NotificationDetails_() {
    return const AndroidNotificationDetails(
      "Catodo_channel_id",
      "Catodo channel",
      channelDescription: "description channel",
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  Future<void> ShowNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,

      const NotificationDetails(),
    );
  }
}
