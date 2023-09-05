import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:flutter/material.dart';

class Paginator extends StatelessWidget {
  const Paginator({
    super.key,
    required this.currentPageIndex,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  final int currentPageIndex;
  final Function() onPreviousPage;
  final Function() onNextPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: onPreviousPage,
            icon: const MyIcon(icon: AppAssets.icArrowLeftSquare)),
        Text("${currentPageIndex + 1}"),
        IconButton(
            onPressed: onNextPage,
            icon: const MyIcon(icon: AppAssets.icArrowRightSquare)),
      ],
    );
  }
}
