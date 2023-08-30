import 'package:admin_ecommerce_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:admin_ecommerce_app/helpers/local_navigator.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/side_menu.dart';
import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:admin_ecommerce_app/screens/product_screen/product_screen.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/support_screen/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  final Widget? child;

  const MainScreen({super.key, this.child});

  static const String routeName = "/";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final routes = <String>[
    DashboardScreen.routeName,
    ProductScreen.routeName,
    OrderScreen.routeName,
    PromotionScreen.routeName,
    SupportScreen.routeName,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (Responsive.isDesktop(context))
          Expanded(
              child: SideMenu(
            currentIndex: currentIndex,
            onSelectItem: _onSelectItem,
          )),
        Expanded(
          flex: 5,
          child: localNavigator(context),
        )
      ]),
    );
  }

  void _onSelectItem(int index) {
    setState(() {
      currentIndex = index;
    });
    context.read<NavigationBloc>().add(NavigateTo(routeName: routes[index]));
  }
}
