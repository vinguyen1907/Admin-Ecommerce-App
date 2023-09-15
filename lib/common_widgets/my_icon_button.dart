import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final Function onPressed;
  final Widget icon;
  final double size;
  final Color color;
  const MyIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: size / 2,
        backgroundColor: color,
        child: IconButton(onPressed: () => onPressed(), icon: icon));
  }
}
