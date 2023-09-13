import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/notification_type.dart';
import 'package:admin_ecommerce_app/models/user_notification.dart';
import 'package:admin_ecommerce_app/services/notification_service.dart';

class NotificationRepository {
  Future<void> addNotification(
      {required UserNotification notification,
      required String receiverId,
      String? imgUrl,
      required NotificationType type}) async {
    try {
      final fcmToken = await getFcmToken(receiverId);
      if (fcmToken == null) {
        throw Exception("This user is not available.");
      }

      final doc = notificationsRef.doc();
      final List<Future> futures = [
        notificationsRef.add(notification.copyWith(id: doc.id).toMap()),
        NotificationService().sendNotification(
          fcmToken: fcmToken,
          title: notification.title,
          body: notification.content,
          imgUrl: imgUrl,
          type: type,
        ),
      ];

      await Future.wait(futures);
    } catch (e) {
      print("Add notification exception: $e");
    }
  }

  Future<String?> getFcmToken(String userId) async {
    try {
      final userDoc = await usersRef.doc(userId).get();
      return userDoc.get('fcmToken') as String;
    } catch (e) {
      print("Get fcm token exception: $e");
      return null;
    }
  }
}
