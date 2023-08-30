import 'package:admin_ecommerce_app/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/dashboard_charts.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/dashboard_statistics_item.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/latest_orders_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String routeName = "/dashboard-screen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardError) {
          return const Center(child: Text("Error"));
        }
        if (state is DashboardLoaded) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.defaultHorizontalContentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenNameSection("Dashboard"),
                  Row(
                    children: [
                      DashboardStatisticsItem(
                        title: "Total Sales",
                        value: state.totalSales,
                        iconAsset: AppAssets.icDollar,
                        iconInnerColor: Colors.orangeAccent,
                        iconOuterColor: Colors.orangeAccent.withOpacity(0.3),
                      ),
                      const SizedBox(width: 20),
                      DashboardStatisticsItem(
                        title: "Total Orders",
                        value: state.totalOrders.toDouble(),
                        iconAsset: AppAssets.icBagBold,
                        iconInnerColor: Colors.greenAccent,
                        iconOuterColor: Colors.greenAccent.withOpacity(0.3),
                      ),
                      const SizedBox(width: 20),
                      DashboardStatisticsItem(
                        title: "Total Products",
                        value: state.productCount.toDouble(),
                        iconAsset: AppAssets.icBoxBold,
                        iconInnerColor: Colors.blueAccent,
                        iconOuterColor: Colors.blueAccent.withOpacity(0.3),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  DashboardCharts(orders: state.orders),
                  LatestOrdersTable(orders: state.orders),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
