// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrdersMonthlyStatistics {
  final int month;
  final int year;
  final double revenue;
  final int ordersCount;

  OrdersMonthlyStatistics({
    required this.month,
    required this.year,
    required this.revenue,
    required this.ordersCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'month': month,
      'year': year,
      'revenue': revenue,
      'ordersCount': ordersCount,
    };
  }

  factory OrdersMonthlyStatistics.fromMap(Map<String, dynamic> map) {
    return OrdersMonthlyStatistics(
      month: int.parse((map['id'] as String).split("-").last),
      year: int.parse((map['id'] as String).split("-").first),
      revenue: map['revenue'] ?? 0,
      ordersCount: map['ordersCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdersMonthlyStatistics.fromJson(String source) =>
      OrdersMonthlyStatistics.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
