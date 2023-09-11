import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/extensions/order_status_extensions.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/order_product_detail.dart';
import 'package:admin_ecommerce_app/models/orders_with_last_doc.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  // Future<List<OrderModel>> fetchAllOrders() async {
  //   try {
  //     final snapshot =
  //         await ordersRef.orderBy("createdAt", descending: true).get();
  //     return snapshot.docs
  //         .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  Future<OrdersWithLastDoc> fetchLatestOrders() async {
    try {
      final snapshot = await ordersRef
          .orderBy("createdAt", descending: true)
          .limit(AppConstants.numberItemsPerPage)
          .get();
      final List<OrderModel> orders = snapshot.docs
          .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return OrdersWithLastDoc(
          orders: orders,
          lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<OrderProductDetail>> fetchOrderItems(String orderId) async {
    try {
      final snapshot = await ordersRef.doc(orderId).collection("items").get();
      return snapshot.docs
          .map((e) => OrderProductDetail.fromMap(e.data()))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<TrackingStatus>> fetchOrderTracking(String orderId) async {
    try {
      final snapshot = await ordersRef
          .doc(orderId)
          .collection("tracking")
          .orderBy("createAt", descending: true)
          .get();
      return snapshot.docs
          .map((e) => TrackingStatus.fromMap(e.data()))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateOrderStatus(String orderId, TrackingStatus status) async {
    try {
      // update currentOrderStatus in order document
      await ordersRef
          .doc(orderId)
          .update({"currentOrderStatus": status.status.statusCode});
      // add new tracking status to tracking collection
      final doc = ordersRef.doc(orderId).collection("tracking").doc();
      await doc.set(status.copyWith(id: doc.id).toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OrdersWithLastDoc> fetchMoreOrders(
      {required DocumentSnapshot lastDocument, required int limit}) async {
    try {
      final snapshot = await ordersRef
          .orderBy("createdAt", descending: true)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get();
      final List<OrderModel> orders = snapshot.docs
          .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return OrdersWithLastDoc(
          orders: orders,
          lastDocument:
              snapshot.docs.isNotEmpty ? snapshot.docs.last : lastDocument);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<OrderModel>> searchOrder(String query) async {
    try {
      final snapshot =
          await ordersRef.where("orderNumber", isEqualTo: query).get();
      return snapshot.docs
          .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
