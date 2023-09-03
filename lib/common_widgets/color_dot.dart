import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ColorDotWidget extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const ColorDotWidget(
      {super.key, required this.color, this.height = 10, this.width = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.darkGreyColor,
        ),
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
