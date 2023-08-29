import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/drawer_listtile.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
              height: 80,
              child: DrawerHeader(child: MyIcon(icon: AppAssets.icAppIcon))),
          DrawerListTile(
            icon: AppAssets.icChart,
            selectedIcon: AppAssets.icChartBold,
            isSelected: selectedIndex == 0,
            title: "Dashboard",
            onTap: () => _onSelectItem(0),
          ),
          DrawerListTile(
            icon: AppAssets.icBox,
            selectedIcon: AppAssets.icBoxBold,
            isSelected: selectedIndex == 1,
            title: "Product",
            onTap: () => _onSelectItem(1),
          ),
          DrawerListTile(
            icon: AppAssets.icBag,
            selectedIcon: AppAssets.icBagBold,
            isSelected: selectedIndex == 2,
            title: "Order",
            onTap: () => _onSelectItem(2),
          ),
          DrawerListTile(
            icon: AppAssets.icPromotion,
            selectedIcon: AppAssets.icPromotionBold,
            isSelected: selectedIndex == 3,
            title: "Promotion",
            onTap: () => _onSelectItem(3),
          ),
          DrawerListTile(
            icon: AppAssets.icSms,
            selectedIcon: AppAssets.icSmsBold,
            isSelected: selectedIndex == 4,
            title: "Support",
            onTap: () => _onSelectItem(4),
          ),
          const Spacer(),
          DrawerListTile(
            icon: AppAssets.icLogout,
            selectedIcon: AppAssets.icLogout,
            isSelected: false,
            title: "Logout",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _onSelectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
