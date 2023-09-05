import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
      {super.key, required this.onPressed, required this.widget});
  final VoidCallback onPressed;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.all(16)
                : const EdgeInsets.all(10),
            textStyle: AppStyles.titleSmall,
            foregroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        onPressed: onPressed,
        child: widget);
  }
}
