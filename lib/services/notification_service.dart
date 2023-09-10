import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:dio/dio.dart';

class NotificationService {
  Future<void> sendNotification(
      String fcmToken, String title, String body) async {
    var postUrl = AppConstants.fcmPostUrl;
    var data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
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
}
