import 'package:admin_ecommerce_app/helpers/local_navigator.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_ecommerce_app/screens/employee_screen/employee_screen.dart';
import 'package:admin_ecommerce_app/screens/main_screen/widgets/side_menu.dart';
import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:admin_ecommerce_app/screens/product_screen/product_screen.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/support_screen/support_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final Widget? child;

  const MainScreen({super.key, this.child});

  static const String routeName = "/main-screen";

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
    EmployeeScreen.routeName
  ];

  @override
  void initState() {
    super.initState();
    // context.read<NavigationBloc>().add(const CreateNavigatorState());
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        currentIndex: currentIndex,
        onSelectItem: _onSelectItem,
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (Responsive.isDesktop(context))
          Expanded(
              child: SideMenu(
            currentIndex: currentIndex,
            onSelectItem: _onSelectItem,
          )),
        Expanded(
          flex: 5,
          child: SafeArea(
              child: LocalNavigator(
            navigatorKey: navigatorKey,
          )),
        )
      ]),
    );
  }

  void _onSelectItem(int index) {
    print(index);
    print(routes[index]);
    setState(() {
      currentIndex = index;
    });
    navigatorKey.currentState!.pushNamed(
      routes[index],
    );
    // Navigator.pushNamed(context, routes[index]);
    // context.read<NavigationBloc>().add(NavigateTo(routeName: routes[index]));
  }
}
