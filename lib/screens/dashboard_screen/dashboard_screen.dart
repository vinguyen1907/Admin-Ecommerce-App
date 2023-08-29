import 'package:admin_ecommerce_app/screens/order_screen/order_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const String routeName = "/dashboard-screen";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderScreen.routeName);
      },
      child: const Center(
        child: Text("Dashboard"),
      ),
    );
  }
}
