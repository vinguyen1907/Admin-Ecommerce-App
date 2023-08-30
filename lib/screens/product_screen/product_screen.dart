import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  static const String routeName = "/product-screen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Product screen"),
    ));
  }
}
