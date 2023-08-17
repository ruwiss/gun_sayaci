import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const initializationsSettings =
        InitializationSettings(android: androidInitialize);
    await _notifications.initialize(initializationsSettings);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "GunSayaci",
        "day_counterr_1",
        importance: Importance.max,
      ),
    );
  }

  static Future showNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDateTime,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDateTime, tz.local),
          await _notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  static Future unScheduleAllNotifications() async =>
      await _notifications.cancelAll();
}
