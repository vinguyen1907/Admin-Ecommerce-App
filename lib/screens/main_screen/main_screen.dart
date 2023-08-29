import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (Responsive.isDesktop(context))
          const Expanded(flex: 1, child: SideMenu()),
        Expanded(
          flex: 5,
          child: Container(),
        )
      ]),
    );
  }
}
