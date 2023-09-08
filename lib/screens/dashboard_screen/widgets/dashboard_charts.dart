import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/orders_monthly_statistics.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/sales_statistics_chart.dart';
import 'package:flutter/material.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({
    super.key,
    required this.monthlyStatistics,
  });

  final List<OrdersMonthlyStatistics> monthlyStatistics;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double barChartSectionWidth = ((size.width * 5 / 6) -
                AppDimensions.defaultHorizontalContentPadding * 2 -
                40) *
            2 /
            3 +
        20;
    final double height = barChartSectionWidth / 3 + 70;

    return Row(
      children: [
        PrimaryBackground(
          width: barChartSectionWidth,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sale statistics", style: AppStyles.labelMedium),
              const SizedBox(height: 20),
              SalesStatisticsChart(
                monthlyStatistics: monthlyStatistics,
              )
            ],
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: PrimaryBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sale statistics",
                  style: AppStyles.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
