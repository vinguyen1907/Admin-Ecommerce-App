import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ScreenNameSection extends StatelessWidget {
  final EdgeInsets? margin;
  final String screenName;
  final bool hasDefaultBackButton;
  const ScreenNameSection(this.screenName,
      {super.key, this.margin, this.hasDefaultBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 10, bottom: 18),
      child: Row(
        children: [
          if (hasDefaultBackButton)
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const MyIcon(
                  icon: AppAssets.icArrowLeft,
                )),
          Text(
            screenName,
            style: AppStyles.displayLarge,
          ),
        ],
      ),
    );
  }
}
