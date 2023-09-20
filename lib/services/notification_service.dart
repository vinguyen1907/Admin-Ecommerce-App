import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/models/notification_type.dart';
import 'package:dio/dio.dart';

class NotificationService {
  Future<void> sendNotification(
      {required String fcmToken,
      required String title,
      required String body,
      String? imgUrl,
      required NotificationType type}) async {
    var postUrl = AppConstants.fcmPostUrl;
    var data = {
      "notification": {"body": body, "title": title},
      // "priority": "high",
      "data": {
        "type": type.name,
      },
      "to": fcmToken
    };
    var headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${AppConstants.fcmApiKey}'
    };
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: headers,
    );
    try {
      final response = await Dio(options).post(postUrl, data: data);
      if (response.statusCode == 200) {
        print('notification sent');
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print('Send notification exception: $e');
    }
  }

  Future<bool> sendNotificationToAll(
      {required String title,
      required String content,
      required NotificationType type}) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm',
        headers: {
          'content-type': 'application/json',
          'Authorization': 'key=${AppConstants.fcmApiKey}'
        },
      ),
    );

    final data = {
      "to": "/topics/all",
      "collapse_key": "type_a",
      "priority": "high",
      "notification": {
        "title": title,
        "body": content,
      },
      "data": {
        "type": type.name,
      },
    };

    try {
      final response = await dio.post(
        '/send',
        data: data,
      );

      if (response.statusCode == 200) {
        print('Notification sent');
        return true;
      } else {
        print('Notification sending failed');
        return false;
      }
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }
}
