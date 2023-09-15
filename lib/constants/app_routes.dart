import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/chat_screen.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_ecommerce_app/screens/edit_product_screen/edit_product_screen.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_ecommerce_app/screens/edit_employee_screen/edit_employee_screen.dart';
import 'package:admin_ecommerce_app/screens/edit_promotion_screen/edit_promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/employee_screen/employee_screen.dart';
import 'package:admin_ecommerce_app/screens/main_screen/main_screen.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/order_detail_screen.dart';
import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:admin_ecommerce_app/screens/product_screen/product_screen.dart';
import 'package:admin_ecommerce_app/screens/add_product_screen/add_product_screen.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/record_voice_screen/record_voice_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignInScreen.routeName:
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case MainScreen.routeName:
        return MaterialPageRoute(builder: (context) => const MainScreen());
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
      case AddProductScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const AddProductScreen());
      case EmployeeScreen.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const EmployeeScreen());
      case OrderDetailScreen.routeName:
        final args = settings.arguments as OrderModel;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => OrderDetailScreen(order: args));
      case EditProductScreen.routeName:
        final args = settings.arguments as Product;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => EditProductScreen(product: args));
      case RecordVoiceScreen.routeName:
        final args = settings.arguments as ChatRoom;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => RecordVoiceScreen(
                  chatRoom: args,
                ));
      case ChatScreen.routeName:
        final args = settings.arguments as ChatRoom;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => ChatScreen(
                  chatRoom: args,
                ));
      case EditPromotionScreen.routeName:
        final args = settings.arguments as Promotion?;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => EditPromotionScreen(promotion: args));
      case EditEmployeeScreen.routeName:
        final args = settings.arguments as Employee?;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => EditEmployeeScreen(employee: args));

      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(child: Text("No route")),
                ));
    }
  }
}
