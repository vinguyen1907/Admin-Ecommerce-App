import 'package:admin_ecommerce_app/blocs/user_bloc/user_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/drawer_listtile.dart';
import 'package:admin_ecommerce_app/screens/sign_in_screen/sign_in_screen.dart';
import 'package:admin_ecommerce_app/services/firebase_auth_service.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
    required this.onSelectItem,
    required this.currentIndex,
  });
  final Function(int) onSelectItem;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final drawerTileTitles = [
      "Dashboard",
      'Product',
      'Order',
      'Promotion',
      'Support',
    ];
    final drawerTileIcons = <String>[
      AppAssets.icChart,
      AppAssets.icBox,
      AppAssets.icBag,
      AppAssets.icPromotion,
      AppAssets.icSms,
    ];
    final drawerTileIconsSelected = <String>[
      AppAssets.icChartBold,
      AppAssets.icBoxBold,
      AppAssets.icBagBold,
      AppAssets.icPromotionBold,
      AppAssets.icSmsBold,
    ];

    return Builder(builder: (context) {
      return Drawer(
        surfaceTintColor: AppColors.whiteColor,
        child: Column(
          children: [
            const SizedBox(
                height: 80,
                child: DrawerHeader(child: MyIcon(icon: AppAssets.icAppIcon))),
            ListView.builder(
                shrinkWrap: true,
                itemCount: drawerTileTitles.length,
                itemBuilder: (_, index) {
                  return DrawerListTile(
                    icon: drawerTileIcons[index],
                    selectedIcon: drawerTileIconsSelected[index],
                    isSelected: currentIndex == index,
                    title: drawerTileTitles[index],
                    onTap: () => onSelectItem(index),
                  );
                }),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  if (state.user.type == UserType.admin) {
                    return DrawerListTile(
                      icon: AppAssets.icPeople,
                      selectedIcon: AppAssets.icPeopleBold,
                      isSelected: currentIndex == drawerTileTitles.length,
                      title: "Employee",
                      onTap: () => onSelectItem(drawerTileTitles.length),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
            const Spacer(),
            DrawerListTile(
              icon: AppAssets.icLogout,
              selectedIcon: AppAssets.icLogout,
              isSelected: false,
              title: "Logout",
              onTap: () => _onSignOut(context),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _onSignOut(BuildContext context) async {
    await FirebaseAuthService().signOut();
    Utils.changeSignInState(false);
    Navigator.popAndPushNamed(context, SignInScreen.routeName);
  }
}
