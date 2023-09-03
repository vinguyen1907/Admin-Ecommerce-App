import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ScreenNameSection extends StatelessWidget {
  final EdgeInsets? margin;
  final String screenName;
  final bool hasBackButton;
  const ScreenNameSection(this.screenName,
      {super.key, this.margin, this.hasBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 10, bottom: 18),
      child: Row(
        children: [
          if (hasBackButton)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          Text(
            screenName,
            style: AppStyles.displayLarge,
          ),
        ],
      ),
    );
  }
}
