import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:admin_ecommerce_app/screens/product_screen/product_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const String routeName = "/dashboard-screen";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductScreen.routeName);
          },
          child: Text("Dashboard")),
    );
  }
}
