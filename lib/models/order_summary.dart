import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderSummary {
  final double amount;
  final double shipping;
  final double promotionDiscount;
  final double total;
  OrderSummary({
    required this.amount,
    required this.shipping,
    required this.promotionDiscount,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'shipping': shipping,
      'promotionDiscount': promotionDiscount,
      'total': total,
    };
  }

  factory OrderSummary.fromMap(Map<String, dynamic> map) {
    return OrderSummary(
      amount: map['amount'] as double,
      shipping: map['shipping'] as double,
      promotionDiscount: map['promotionDiscount'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSummary.fromJson(String source) =>
      OrderSummary.fromMap(json.decode(source) as Map<String, dynamic>);
}
