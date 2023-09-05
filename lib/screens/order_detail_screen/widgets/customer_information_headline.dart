import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class CustomerInformationHeadline extends StatelessWidget {
  const CustomerInformationHeadline({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  final String icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MyIcon(icon: icon),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.labelMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ],
    );
  }
}
