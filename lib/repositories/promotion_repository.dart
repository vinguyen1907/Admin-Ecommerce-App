import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/models/promotions_with_last_doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionRepository {
  Future<PromotionsWithLastDoc> fetchLatestPromotions() async {
    try {
      final snapshot = await promotionsRef
          .orderBy("endTime", descending: true)
          .where("isDeleted", isEqualTo: false)
          .limit(AppConstants.numberItemsPerPage)
          .get();
      snapshot.docs.forEach((element) {
        print(element.data().toString());
      });
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
      final doc = promotionsRef.doc();
      await doc.set(promotion.copyWith(id: doc.id).toMap());
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
