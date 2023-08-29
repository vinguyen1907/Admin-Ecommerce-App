import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/drawer_listtile.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: MyIcon(icon: AppAssets.icAppIcon)),
          DrawerListTile(
            icon: AppAssets.icChart,
            title: "Dashboard",
            onTap: () {},
          ),
          DrawerListTile(
            icon: AppAssets.icBox,
            title: "Product",
            onTap: () {},
          ),
          DrawerListTile(
            icon: AppAssets.icBag,
            title: "Order",
            onTap: () {},
          ),
          DrawerListTile(
            icon: AppAssets.icPromotion,
            title: "Promotion",
            onTap: () {},
          ),
          DrawerListTile(
            icon: AppAssets.icSms,
            title: "Support",
            onTap: () {},
          ),
          const Spacer(),
          DrawerListTile(
            icon: AppAssets.icLogout,
            title: "Logout",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
