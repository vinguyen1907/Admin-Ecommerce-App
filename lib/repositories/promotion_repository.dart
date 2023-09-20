import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/notification_type.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/models/promotions_with_last_doc.dart';
import 'package:admin_ecommerce_app/models/user_notification.dart';
import 'package:admin_ecommerce_app/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionRepository {
  Future<PromotionsWithLastDoc> fetchLatestPromotions() async {
    try {
      final snapshot = await promotionsRef
          .orderBy("endTime", descending: true)
          .where("isDeleted", isEqualTo: false)
          .limit(AppConstants.numberItemsPerPage)
          .get();

      final List<Promotion> promotions = snapshot.docs
          .map((e) => Promotion.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return PromotionsWithLastDoc(
          promotions: promotions,
          lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PromotionsWithLastDoc> fetchMorePromotions(
      {required DocumentSnapshot lastDocument, required int limit}) async {
    try {
      final snapshot = await promotionsRef
          .orderBy("endTime", descending: true)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get();
      final List<Promotion> promotions = snapshot.docs
          .map((e) => Promotion.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return PromotionsWithLastDoc(
          promotions: promotions,
          lastDocument:
              snapshot.docs.isNotEmpty ? snapshot.docs.last : lastDocument);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Promotion>> searchOrder(String query) async {
    try {
      final snapshot =
          await promotionsRef.where("code", isEqualTo: query).get();
      return snapshot.docs
          .map((e) => Promotion.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletePromotion(String id) async {
    try {
      await promotionsRef.doc(id).update({"isDeleted": true});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addPromotion({required Promotion promotion}) async {
    try {
      final promotionDoc = promotionsRef.doc();
      const String title = "New promotion";
      final String content =
          "${promotion.code} - ${promotion.amount == 0 ? "Free shipping" : "${promotion.amountString} discount"}";
      final notificationDoc = notificationsRef.doc();
      final notification = UserNotification(
          id: notificationDoc.id,
          userId: "",
          title: "New promotion",
          content: content,
          createdAt: DateTime.now(),
          type: NotificationType.promotion);

      final List<Future> futures = [
        // Add promotion in Firestore
        promotionDoc.set(promotion.copyWith(id: promotionDoc.id).toMap()),
        // Add notification in Firestore
        notificationDoc.set(notification.toMap()),
        // Send notification using FCM
        NotificationService().sendNotificationToAll(
            title: title, content: content, type: NotificationType.promotion),
      ];

      await Future.wait(futures);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePromotion({required Promotion promotion}) async {
    try {
      await promotionsRef.doc(promotion.id).update(promotion.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }
}
