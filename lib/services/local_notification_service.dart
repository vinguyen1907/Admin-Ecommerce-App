// import 'dart:developer';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await _localNotificationsPlugin.initialize(
//       initializationSettings,
//     );
//   }
//
//   static Future<void> showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'channel chat',
//       'channel chat',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     _localNotificationsPlugin.show(0, message.notification!.title,
//         message.notification!.body, notificationDetails);
//   }
//
//   static Future<void> showNotificationWithPicture(RemoteMessage message) async {
//     final Dio dio = Dio();
//     final imgUrl = message.data['imgUrl'];
//     final Directory tempDir = await getTemporaryDirectory();
//     final String tempPath = '${tempDir.path}/image.jpg';
//     try {
//       await dio.download(
//         imgUrl,
//         tempPath,
//       );
//     } catch (e) {
//       log('Error downloading image: $e');
//       return;
//     }
//     final BigPictureStyleInformation bigPictureStyleInformation =
//         BigPictureStyleInformation(
//       FilePathAndroidBitmap(tempPath),
//     );
//     final AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channel general', 'channel general',
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: bigPictureStyleInformation,
//             color: Colors.black);
//
//     final NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//
//     await _localNotificationsPlugin.show(
//       0,
//       message.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//     );
//   }
//
//   static Future<void> handleMessage(RemoteMessage message) async {
//     if (message.data['type'] == 'chat') {
//       await showNotification(message);
//     } else if (message.data['type'] == 'statusOrder') {
//       await showNotification(message);
//     } else if (message.data['type'] == 'promotion') {
//       await showNotificationWithPicture(message);
//     } else if (message.data['type'] == 'advertisement') {
//       await showNotificationWithPicture(message);
//     }
//   }
// }
