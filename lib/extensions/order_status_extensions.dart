import 'package:admin_ecommerce_app/models/order_status.dart';

extension OrderStatusExt on OrderStatus {
  String toOrderStatusString() {
    return orderStatusToString[this] ??
        orderStatusToString[OrderStatus.pending]!;
  }

  String get statusName =>
      orderStatusName[this] ?? orderStatusName[OrderStatus.pending]!;
}
