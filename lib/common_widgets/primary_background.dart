import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class PrimaryBackground extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const PrimaryBackground({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: AppDimensions.defaultBorderRadius,
        color: AppColors.whiteColor,
      ),
      child: child,
    );
  }
}
