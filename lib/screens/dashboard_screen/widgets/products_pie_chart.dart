import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductsPieChart extends StatefulWidget {
  const ProductsPieChart(
      {super.key, required this.topProducts, required this.totalSoldCount});

  final List<Product> topProducts;
  final int totalSoldCount;

  @override
  State<StatefulWidget> createState() => ProductPieChartState();
}

class ProductPieChartState extends State<ProductsPieChart> {
  int touchedIndex = -1;
  final List<Color> indicatorColors = [
    const Color(0xFF023e8a),
    const Color(0xFF0096c7),
    const Color(0xFF00b4d8),
    const Color(0xFF48cae4),
    const Color(0xFF90e0ef),
    const Color(0xFFcaf0f8),
  ];
  final List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    data.addAll(generateData());
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Column(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) => Indicator(
              color: data[index]["color"],
              text: data[index]["name"],
              isSquare: true,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final desktopRadius = isTouched ? 40.0 : 30.0;
      final tabletRadius = isTouched ? 30.0 : 10.0;
      final double radius =
          Responsive.isDesktop(context) ? desktopRadius : tabletRadius;
      final value = data[i]["value"];
      return PieChartSectionData(
          color: data[i]["color"],
          value: value.toDouble(),
          title: '${value / widget.totalSoldCount * 100}%',
          radius: radius,
          titleStyle: AppStyles.bodySmall.copyWith(
              fontSize: fontSize,
              color: isTouched ? AppColors.primaryColor : Colors.transparent));
    });
  }

  List<Map<String, dynamic>> generateData() {
    final List<Map<String, dynamic>> data = [];
    int total = 0;
    for (int i = 0; i < widget.topProducts.length; i++) {
      if (widget.topProducts[i].soldCount != 0) {
        data.add({
          "name": widget.topProducts[i].name,
          "value": widget.topProducts[i].soldCount,
          "color": indicatorColors[i % indicatorColors.length],
        });
        total += widget.topProducts[i].soldCount;
      }
    }
    if (total < widget.totalSoldCount) {
      data.add({
        "name": "Others",
        "value": widget.totalSoldCount - total,
        "color": indicatorColors[5 % indicatorColors.length],
      });
    }
    return data;
  }
}
