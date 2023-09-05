import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:flutter/material.dart';

class OrderSummaryLine extends StatelessWidget {
  const OrderSummaryLine({
    super.key,
    required this.label,
    required this.number,
    this.numberFontSize,
  });

  final String label;
  final double number;
  final double? numberFontSize;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: Responsive.isMobile(context)
          ? size.width * 0.4
          : Responsive.isTablet(context)
              ? size.width * 0.25
              : size.width * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppStyles.labelMedium
                  .copyWith(color: AppColors.greyTextColor)),
          Text(number.toPriceString(),
              style: AppStyles.labelLarge.copyWith(fontSize: numberFontSize)),
        ],
      ),
    );
  }
}
