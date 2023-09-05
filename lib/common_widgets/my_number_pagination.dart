import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class MyNumberPagination extends StatelessWidget {
  const MyNumberPagination({
    super.key,
    required this.pageTotal,
    required this.pageInit,
    required this.onPageChanged,
  });

  final int pageTotal;
  final int pageInit;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return NumberPagination(
      threshold: 4,
      controlButton: const SizedBox(),
      onPageChanged: onPageChanged,
      pageTotal: pageTotal,
      pageInit: pageInit, // picked number when init page
      colorPrimary: AppColors.primaryColor,
      colorSub: AppColors.whiteColor,
    );
  }
}
