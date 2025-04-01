import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wisdom/app.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/main.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/invite_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/rematch_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/searching_opponent_viewmodel.dart';

class AppNotificationService {
  static AppNotificationService get to => locator.get<AppNotificationService>();

  static bool isFlutterLocalNotificationsInitialized = false;
  int reminderId = 111;
  final String _reminderTitle = "Wisdom";
  final String _reminderBody = "Yangi so’zlarni qaytarish payti keldi";

  void showTopDialog(Map<String, dynamic> messageData) {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: "Top Dialog",
      pageBuilder: (context, anim1, anim2) {
        return InviteBattleDialog(
          messageData: messageData,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future initNotification() async {
    if (Platform.isWindows) return;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings? settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) showNotification(message, '');
      if (message.data.isNotEmpty) {
        final messageData = message.data;
        if (messageData['type'] == 'battle_invitation') {
          showTopDialog(messageData);
        }
      }
    });
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        locator<LocalViewModel>().changePageIndex(1);
        print("Notification callback worked from alive");
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().then((details) async {
      if (details != null) {
        if (details.didNotificationLaunchApp) {
          Future.delayed(
            const Duration(seconds: 1),
            () => locator<LocalViewModel>().changePageIndex(1),
          );
          print("Notification callback worked from dead");
        }
      }
    });
  }

  Future<bool> requestNotificationPermission() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings? settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await initNotification();
        return true;
      } else {}
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future showNotification(RemoteMessage message, String playLoad) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('Takk', 'Takk channel',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        actions: [
          AndroidNotificationAction(
            'reply',
            'Reply',
          ),
          AndroidNotificationAction(
            'dismiss',
            'Dismiss',
          ),
        ]);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: playLoad,
    );
  }

  void cancelAll() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      return grantedNotificationPermission ?? false;
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return true;
    }
    return false;
  }

  Future scheduleHourlyNotification({
    int id = 0,
    String? title,
    String? body,
    int? hour,
  }) async {
    cancelAll();
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      channelDescription: 'repeating description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      sound: 'slow_spring_board.aiff',
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      reminderId,
      _reminderTitle,
      _reminderBody,
      RepeatInterval.hourly,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future scheduleDailyNotification({
    int id = 0,
    String? title,
    String? body,
    int? hour,
    int? minute,
  }) async {
    cancelAll();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminderId,
      _reminderTitle,
      _reminderBody,
      _nextInstanceOfTime(hour ?? 0, minute ?? 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          channelDescription: 'daily notification description',
          sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        ),
        iOS: DarwinNotificationDetails(sound: 'slow_spring_board.mp3'),
      ),
      payload: '',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(
    int hour,
    int minute,
  ) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    print(scheduledDate.toString());
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @pragma('vm:entry-point')
  static notificationTapBackground(NotificationResponse notificationResponse) {
    log("Notification: ${notificationResponse.actionId!}");
    Future.delayed(
      const Duration(seconds: 1),
      () => locator<LocalViewModel>().changePageIndex(1),
    );
    // locator<LocalViewModel>().changePageIndex(1);
  }

  @pragma('vm:entry-point')
  Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await setupFlutterNotifications();
    if (Platform.isAndroid) showNotification(message, '');
  }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }
}
