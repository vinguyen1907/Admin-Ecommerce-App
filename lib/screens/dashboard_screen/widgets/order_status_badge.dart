import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/extensions/order_status_extensions.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/order_status.dart';
import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (order.currentOrderStatus) {
      OrderStatus.delivered => AppColors.successfulBackgroundColor,
      OrderStatus.pending => AppColors.pendingBackgroundColor,
      OrderStatus.cancelled ||
      OrderStatus.failedDelivery ||
      OrderStatus.returned =>
        AppColors.failedBackgroundColor,
      _ => AppColors.inProgressBackgroundColor,
    };
    final textColor = switch (order.currentOrderStatus) {
      OrderStatus.delivered => AppColors.successfulTextColor,
      OrderStatus.pending => AppColors.pendingTextColor,
      OrderStatus.cancelled ||
      OrderStatus.failedDelivery ||
      OrderStatus.returned =>
        AppColors.failedTextColor,
      _ => AppColors.inProgressTextColor,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimensions.roundedCorners,
      ),
      child: Text(
        order.currentOrderStatus.statusName,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
