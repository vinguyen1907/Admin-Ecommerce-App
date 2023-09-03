import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/extensions/order_status_extensions.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/order_product_detail.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';

class OrderRepository {
  Future<Map<String, double>> getSalesStatistics() async {
    final snapshot = await ordersRef.get();
    return {
      'total_orders': snapshot.docs.length.toDouble(),
      'total_sales': snapshot.docs.isEmpty
          ? 0
          : snapshot.docs.fold(
              0,
              (previousValue, element) =>
                  previousValue +
                  (element.data() as Map<String, dynamic>)['orderSummary']
                      ['total']),
    };
  }

  Future<List<OrderModel>> fetchAllOrders() async {
    try {
      final snapshot =
          await ordersRef.orderBy("createdAt", descending: true).get();
      return snapshot.docs
          .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
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
}
