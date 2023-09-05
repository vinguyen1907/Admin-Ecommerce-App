import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:flutter/material.dart';

class ScreenHorizontalPaddingWidget extends StatelessWidget {
  const ScreenHorizontalPaddingWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context)
              ? AppDimensions.mobileHorizontalContentPadding
              : AppDimensions.defaultHorizontalContentPadding),
      child: child,
    );
  }
}
