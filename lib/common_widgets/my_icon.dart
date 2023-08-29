import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyIcon extends StatelessWidget {
  const MyIcon({
    super.key,
    required this.icon,
    this.colorFilter,
    this.width,
    this.height,
  });
  final String icon;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      colorFilter: colorFilter,
      width: width,
      height: height,
    );
  }
}
