import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/models/orders_monthly_statistics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesStatisticsChart extends StatefulWidget {
  final List<OrdersMonthlyStatistics> monthlyStatistics;

  const SalesStatisticsChart({
    super.key,
    required this.monthlyStatistics,
  });

  @override
  State<SalesStatisticsChart> createState() => _SalesStatisticsChartState();
}

class _SalesStatisticsChartState extends State<SalesStatisticsChart> {
  late int showingTooltip;
  late final List<Map<int, double>> barsData;
  double max = 0;

  @override
  void initState() {
    showingTooltip = -1;
    generateBarData();
    super.initState();
  }

  BarChartGroupData generateGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y, color: Colors.blueAccent),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              getTitlesWidget: getBottomTitles,
              showTitles: true,
              interval: 2,
            )),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              reservedSize: 60,
              getTitlesWidget: getLeftTitles,
              showTitles: true,
              interval: calculateInterval(max).toDouble(),
            )),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: calculateInterval(max).toDouble(),
            getDrawingHorizontalLine: (value) => const FlLine(
              color: AppColors.greyColor,
              strokeWidth: 1,
            ),
          ),
          barGroups: [
            ...List.generate(barsData.length, (index) {
              final data = generateGroupData(
                  barsData[index].keys.first, barsData[index].values.first);
              return data;
            }),
            // generateGroupData(1, 103000),
            // generateGroupData(2, 1000),
          ],
          barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchCallback: (event, response) {
                if (response != null &&
                    response.spot != null &&
                    event is FlTapUpEvent) {
                  setState(() {
                    final x = response.spot!.touchedBarGroup.x;
                    final isShowing = showingTooltip == x;
                    if (isShowing) {
                      showingTooltip = -1;
                    } else {
                      showingTooltip = x;
                    }
                  });
                }
              },
              mouseCursorResolver: (event, response) {
                return response == null || response.spot == null
                    ? MouseCursor.defer
                    : SystemMouseCursors.click;
              }),
        ),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta titleMeta) {
    String text = "";
    switch (value) {
      case 1:
        text = "Jan";
        break;
      case 2:
        text = "Feb";
        break;
      case 3:
        text = "Mar";
        break;
      case 4:
        text = "Apr";
        break;
      case 5:
        text = "May";
        break;
      case 6:
        text = "Jun";
        break;
      case 7:
        text = "Jul";
        break;
      case 8:
        text = "Aug";
        break;
      case 9:
        text = "Sep";
        break;
      case 10:
        text = "Oct";
        break;
      case 11:
        text = "Nov";
        break;
      case 12:
        text = "Dec";
        break;
    }
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: AppColors.greyTextColor),
    );
  }

  Widget getLeftTitles(double value, TitleMeta titleMeta) {
    return Text(
      "\$$value",
      style: const TextStyle(fontSize: 12, color: AppColors.greyTextColor),
    );
  }

  void generateBarData() {
    barsData = widget.monthlyStatistics.map((e) {
      if (e.revenue > max) {
        max = e.revenue;
      }
      return {e.month: e.revenue};
    }).toList();
  }

  int calculateInterval(double max) {
    const int horizontalLineCount = 5;
    final digits = max.toInt().toString().length;
    return (max / horizontalLineCount / (digits * 1000)).round() *
        digits *
        1000;
  }
}
