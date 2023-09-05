import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/responsive.dart';
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
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.all(14)
                : const EdgeInsets.all(8),
            minimumSize: Size.zero),
        onPressed: onPressed,
        child: widget);
  }
}
