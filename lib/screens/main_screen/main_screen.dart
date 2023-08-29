import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final Widget? child;

  const MainScreen({super.key, this.child});

  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (Responsive.isDesktop(context))
          const Expanded(flex: 1, child: SideMenu()),
        Expanded(
          flex: 5,
          child: child ?? const SizedBox(),
        )
      ]),
    );
  }
}
