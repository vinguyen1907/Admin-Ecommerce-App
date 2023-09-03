import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentStatusBadge extends StatelessWidget {
  const PaymentStatusBadge({super.key, required this.paymentMethod});

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    final String text = switch (paymentMethod) {
      "cash_on_delivery" => "Cash on delivery",
      _ => "Payment made"
    };
    final Color backgroundColor = switch (paymentMethod) {
      "cash_on_delivery" => AppColors.failedBackgroundColor,
      _ => AppColors.successfulBackgroundColor,
    };
    final Color textColor = switch (paymentMethod) {
      "cash_on_delivery" => AppColors.failedTextColor,
      _ => AppColors.successfulTextColor,
    };

    return Container(
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: AppDimensions.roundedCorners),
        child: Text(
          text,
          style: AppStyles.bodySmall.copyWith(color: textColor),
        ));
  }
}
