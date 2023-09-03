import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.widget,
  });
  final VoidCallback onPressed;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.greyColor),
            padding: const EdgeInsets.all(12),
            minimumSize: Size.zero),
        onPressed: onPressed,
        child: widget);
  }
}
