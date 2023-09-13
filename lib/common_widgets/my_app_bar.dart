import 'package:admin_ecommerce_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppBar extends StatelessWidget implements PreferredSize {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40,
      backgroundColor: Colors.transparent,
      leading: IconButton(
          onPressed: () {
            context
                .read<NavigationBloc>()
                .state
                .scaffoldKey
                .currentState!
                .openDrawer();
          },
          icon: const MyIcon(
            icon: AppAssets.icSidebarRight,
          )),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
