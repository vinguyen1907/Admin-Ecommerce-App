import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyInkWell extends StatelessWidget {
  const MyInkWell(
      {super.key,
      required this.width,
      required this.height,
      required this.child,
      this.onTap});
  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
