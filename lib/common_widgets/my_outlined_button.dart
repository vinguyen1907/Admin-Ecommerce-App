import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    this.height,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: padding,
            side: const BorderSide(color: AppColors.greyTextColor, width: 1),
            minimumSize: Size.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onPressed,
          child: child),
    );
  }
}
