import 'package:admin_ecommerce_app/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/screens/order_screen/widgets/orders_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const String routeName = "/order-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultHorizontalContentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenNameSection("Orders"),
              BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DashboardError) {
                  return const Center(child: Text("Error"));
                }
                if (state is DashboardLoaded) {
                  return OrdersTable(orders: state.orders);
                }
                return const SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }
}
