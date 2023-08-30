import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/extensions/list_order_extension.dart';
import 'package:admin_ecommerce_app/models/order.dart';

class OrderRepository {
  Future<Map<String, double>> getSalesStatistics() async {
    final snapshot = await ordersRef.get();
    final orders = snapshot.docs
        .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    return {
      'total_orders': snapshot.docs.length.toDouble(),
      'total_sales': orders.totalSales,
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
}
