import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/orders_monthly_statistics.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/products_pie_chart.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/sales_statistics_chart.dart';
import 'package:flutter/material.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({
    super.key,
    required this.monthlyStatistics,
    required this.topProducts,
    required this.totalSoldCount,
  });

  final List<OrdersMonthlyStatistics> monthlyStatistics;
  final List<Product> topProducts;
  final int totalSoldCount;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double contentWidth =
        Responsive.isDesktop(context) ? size.width * 5 / 6 : size.width;
    final double barChartSectionWidth = (contentWidth -
                AppDimensions.defaultHorizontalContentPadding * 2 -
                40) *
            2 /
            3 +
        20;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PrimaryBackground(
                  width: barChartSectionWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Sale statistics",
                          style: AppStyles.labelMedium),
                      const SizedBox(height: 20),
                      SalesStatisticsChart(
                        monthlyStatistics: monthlyStatistics,
                      )
                    ],
                  ),
                ),
              ),
              if (!Responsive.isMobile(context)) const SizedBox(width: 20),
              if (!Responsive.isMobile(context))
                PrimaryBackground(
                  width: contentWidth -
                      20 -
                      2 * AppDimensions.defaultHorizontalContentPadding -
                      barChartSectionWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sale statistics",
                        style: AppStyles.labelMedium,
                      ),
                      ProductsPieChart(
                        topProducts: topProducts,
                        totalSoldCount: totalSoldCount,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (Responsive.isMobile(context)) const SizedBox(height: 20),
        if (Responsive.isMobile(context))
          PrimaryBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sale statistics",
                  style: AppStyles.labelMedium,
                ),
                ProductsPieChart(
                  topProducts: topProducts,
                  totalSoldCount: totalSoldCount,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
