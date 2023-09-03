import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TableDivider extends StatelessWidget {
  const TableDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: AppColors.greyColor,
        height: 1,
      ),
    );
  }
}
