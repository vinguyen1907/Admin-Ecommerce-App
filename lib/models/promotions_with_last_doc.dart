import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionsWithLastDoc {
  final List<Promotion> promotions;
  final DocumentSnapshot? lastDocument;

  PromotionsWithLastDoc({
    required this.promotions,
    required this.lastDocument,
  });
}
