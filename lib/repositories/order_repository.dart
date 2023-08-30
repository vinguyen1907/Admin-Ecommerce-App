import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/order.dart';

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
}
