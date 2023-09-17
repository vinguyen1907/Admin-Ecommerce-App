import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final String icon;
  final String selectedIcon;
  final VoidCallback onTap;
  final bool isSelected;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isTablet(context)) {
      return ListTile(
          onTap: onTap,
          leading: MyIcon(
            icon: isSelected ? selectedIcon : icon,
            width: 20,
          ),
          minLeadingWidth: 20,
          title: Text(
            title,
            style: isSelected
                ? AppStyles.drawerListTileTitleSelected
                : AppStyles.drawerListTileTitle,
          ));
    } else if (Responsive.isTablet(context)) {
      return IconButton(
          onPressed: onTap,
          icon: MyIcon(
            icon: isSelected ? selectedIcon : icon,
            width: 20,
          ));
    } else {
      return const SizedBox();
    }
  }
}
