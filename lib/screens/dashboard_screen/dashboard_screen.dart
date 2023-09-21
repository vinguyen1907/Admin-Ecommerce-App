import 'package:admin_ecommerce_app/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_ecommerce_app/blocs/orders_bloc/orders_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/responsive.dart';
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
    _onLoadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLoaded) {
          context.read<OrdersBloc>().add(SetOrders(
              orders: state.latestOrders,
              totalOrdersCount: state.totalOrdersCount,
              lastDocument: state.lastDocument));
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardError) {
          return Center(child: Text(state.message));
        }
        if (state is DashboardLoaded) {
          return Scaffold(
            body: SingleChildScrollView(
              child: ScreenHorizontalPaddingWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenNameSection("Dashboard"),
                    if (Responsive.isMobile(context))
                      Column(
                        children: [
                          DashboardStatisticsItem(
                            title: "Total Sales",
                            value: state.totalSales.toPriceString(),
                            iconAsset: AppAssets.icDollar,
                            iconInnerColor: Colors.orangeAccent,
                            iconOuterColor:
                                Colors.orangeAccent.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          DashboardStatisticsItem(
                            title: "Total Orders",
                            value: state.totalOrdersCount.toString(),
                            iconAsset: AppAssets.icBagBold,
                            iconInnerColor: Colors.greenAccent,
                            iconOuterColor: Colors.greenAccent.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          DashboardStatisticsItem(
                            title: "Total Products",
                            value: state.productCount.toString(),
                            iconAsset: AppAssets.icBoxBold,
                            iconInnerColor: Colors.blueAccent,
                            iconOuterColor: Colors.blueAccent.withOpacity(0.3),
                          )
                        ],
                      ),
                    if (!Responsive.isMobile(context))
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: DashboardStatisticsItem(
                                title: "Total Sales",
                                value: state.totalSales.toPriceString(),
                                iconAsset: AppAssets.icDollar,
                                iconInnerColor: Colors.orangeAccent,
                                iconOuterColor:
                                    Colors.orangeAccent.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DashboardStatisticsItem(
                                title: "Total Orders",
                                value: state.totalOrdersCount.toString(),
                                iconAsset: AppAssets.icBagBold,
                                iconInnerColor: Colors.greenAccent,
                                iconOuterColor:
                                    Colors.greenAccent.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DashboardStatisticsItem(
                                title: "Total Products",
                                value: state.productCount.toString(),
                                iconAsset: AppAssets.icBoxBold,
                                iconInnerColor: Colors.blueAccent,
                                iconOuterColor:
                                    Colors.blueAccent.withOpacity(0.3),
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    DashboardCharts(
                      monthlyStatistics: state.monthlyStatistics,
                      topProducts: state.topProducts,
                      totalSoldCount: state.totalSoldCount,
                    ),
                    LatestOrdersTable(orders: state.latestOrders),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onLoadData() {
    final state = context.read<DashboardBloc>().state;
    if (state is! DashboardLoaded) {
      context.read<DashboardBloc>().add(LoadDashboard());
    }
  }
}
