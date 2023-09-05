import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class HeadlineRichText extends StatelessWidget {
  const HeadlineRichText({
    super.key,
    required this.label,
    required this.content,
  });

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppStyles.bodyMedium,
        children: [
          TextSpan(
            text: content,
            style: AppStyles.bodyMedium.copyWith(color: AppColors.primaryColor),
          )
        ],
      ),
    );
  }
}
