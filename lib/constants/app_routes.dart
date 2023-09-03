import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/order_detail_screen.dart';
import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:admin_ecommerce_app/screens/product_screen/product_screen.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/support_screen/support_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case MainScreen.routeName:
      //   return MaterialPageRoute(builder: (context) => const MainScreen());
      case DashboardScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const DashboardScreen());
      case ProductScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const ProductScreen());
      case OrderScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const OrderScreen());
      case PromotionScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const PromotionScreen());
      case SupportScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const SupportScreen());
      case OrderDetailScreen.routeName:
        final args = settings.arguments as OrderModel;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => OrderDetailScreen(order: args));

      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(child: Text("No route")),
                ));
    }
  }
}
