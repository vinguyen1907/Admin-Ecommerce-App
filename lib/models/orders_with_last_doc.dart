import 'package:admin_ecommerce_app/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersWithLastDoc {
  final List<OrderModel> orders;
  final DocumentSnapshot? lastDocument;

  OrdersWithLastDoc({
    required this.orders,
    required this.lastDocument,
  });
}
