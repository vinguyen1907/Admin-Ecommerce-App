import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ScreenNameSection extends StatelessWidget {
  final EdgeInsets? margin;
  final String screenName;
  const ScreenNameSection(this.screenName, {super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 10, bottom: 18),
      child: Text(
        screenName,
        style: AppStyles.displayLarge,
      ),
    );
  }
}
