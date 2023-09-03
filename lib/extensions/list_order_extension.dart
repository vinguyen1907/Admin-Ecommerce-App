import 'package:admin_ecommerce_app/models/order.dart';

extension ListOrderExt on List<OrderModel> {
  double get totalSales {
    return isEmpty
        ? 0
        : fold(
            0,
            (previousValue, element) =>
                previousValue + element.orderSummary.total);
  }
}
