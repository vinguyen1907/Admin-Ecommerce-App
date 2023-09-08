import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/orders_monthly_statistics.dart';

class StatisticsRepository {
  Future<Map<String, double>> getOrdersStatistics() async {
    final doc = await ordersStatisticsDocRef.get();
    if (doc.exists) {
      return {
        'total_orders':
            (doc.data() as Map<String, dynamic>)['ordersCount'].toDouble(),
        'total_sales':
            (doc.data() as Map<String, dynamic>)['revenue'].toDouble(),
      };
    } else {
      return {
        'total_orders': 0,
        'total_sales': 0,
      };
    }
  }

  Future<Map<String, double>> getProductsStatistics() async {
    final doc = await productsStatisticsDocRef.get();
    if (doc.exists) {
      return {
        'total_products':
            (doc.data() as Map<String, dynamic>)['totalQuantity'].toDouble(),
        'sold_quantity':
            (doc.data() as Map<String, dynamic>)['soldQuantity'].toDouble(),
        'stock_quantity':
            (doc.data() as Map<String, dynamic>)['stockQuantity'].toDouble(),
      };
    } else {
      return {
        'total_products': 0,
        'sold_quantity': 0,
        'stock_quantity': 0,
      };
    }
  }

  Future<List<OrdersMonthlyStatistics>> getMonthlySales() async {
    try {
      final snapshot = await monthlySalesRef.get();
      return snapshot.docs
          .map((e) =>
              OrdersMonthlyStatistics.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
