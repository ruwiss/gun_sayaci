import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gunsayaci/models/data_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  // Nesnemizi oluşturduk
  static final _notifications = FlutterLocalNotificationsPlugin();

  static void permission() async => await Permission.notification.request();

  static Future<void> initialize() async {
    // Bildirim ikonu belirttik.
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const initializationsSettings =
        InitializationSettings(android: androidInitialize);

    // Paketimizi bildirim ikonu belirttikten sonra başlattık.
    await _notifications.initialize(initializationsSettings);
  }

  // Bildirimimizle ilgili tüm ayarları çağırmak üzere burada belirttik.
  static Future<NotificationDetails> _notificationDetails() async =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "DayCounterNotification",
          "day_counter_notification",
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('notification'),
          playSound: true,
          icon: 'notification_icon',
        ),
      );

  // Normal bildirim gösterme.
  static Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload, // bildirime extra veri eklemek istersek
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  // Zamanlanmış bildirim gösterme.
  static Future<void> scheduleNotification({
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
          // TimeZone paketiyle DateTime objesini TZDateTime'e dönüştürdük.
          tz.TZDateTime.from(scheduledDateTime, tz.local),
          await _notificationDetails(),
          // Bildirim tipini burada alarm olarak belirledik.
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          // Bildirim zamanını absolute (gmt) zaman dilimi olarak belirledik.
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  // Tüm zamanlanmış fonksiyonları iptal etme.
  static Future<void> unScheduleAllNotifications() async =>
      await _notifications.cancelAll();

  static bool checkDateIsAfter(DataModel model) {
    final bool value = model.dateTime.isAfter(DateTime.now());
    return value;
  }

  static Future<void> removeSchedule(DataModel model) async {
    await _notifications.cancel(model.id!);
  }

  static Future<void> addSchedule(DataModel model) async {
    await scheduleNotification(
        id: model.id!,
        title: "reminder-title".tr(),
        body: "reminder-body".tr(args: [model.title]),
        scheduledDateTime: model.dateTime);
  }

  static Future<void> updateSchedule(int id, DataModel model) async {
    await removeSchedule(model);
    await addSchedule(model);
  }
}
