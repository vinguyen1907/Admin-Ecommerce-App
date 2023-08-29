import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {}, leading: MyIcon(icon: icon), title: Text(title));
  }
}
