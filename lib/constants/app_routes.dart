import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_ecommerce_app/screens/main_screen/main_screen.dart';
import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case MainScreen.routeName:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case DashboardScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case OrderScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OrderScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text("No route")),
                ));
    }
  }
}
