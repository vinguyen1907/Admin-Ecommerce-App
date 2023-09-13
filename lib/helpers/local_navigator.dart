import 'package:admin_ecommerce_app/constants/app_routes.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:flutter/material.dart';

// Navigator localNavigator(BuildContext context) => Navigator(
//       key: context.read<NavigationBloc>().state.navigatorKey,
//       onGenerateRoute: AppRoutes().onGenerateRoute,
//       initialRoute: DashboardScreen.routeName,
//     );

class LocalNavigator extends StatelessWidget {
  const LocalNavigator({super.key, required this.navigatorKey});

  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: AppRoutes().onGenerateRoute,
      initialRoute: DashboardScreen.routeName,
    );
  }
}
