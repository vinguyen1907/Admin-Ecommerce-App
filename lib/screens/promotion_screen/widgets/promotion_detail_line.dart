import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class PromotionDetailLine extends StatelessWidget {
  const PromotionDetailLine(
      {super.key, required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.bodyLarge),
        const SizedBox(width: 20),
        Text(content,
            style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryColor)),
      ],
    );
  }
}
