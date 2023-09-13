// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/extensions/promotion_type_extensions.dart';
import 'package:admin_ecommerce_app/extensions/string_extensions.dart';
import 'package:admin_ecommerce_app/models/promotion_type.dart';

class Promotion {
  final String id;
  final String code;
  final String content;
  final String imgUrl;
  final PromotionType type;
  final double? minimumOrderValue;
  final double? maximumDiscountValue;
  final DateTime startTime;
  final DateTime endTime;
  final int? quantity; // if it is null, it means unlimited
  final int usedQuantity;
  final bool isDeleted;

  Promotion({
    required this.id,
    required this.code,
    required this.content,
    required this.imgUrl,
    required this.type,
    this.minimumOrderValue,
    this.maximumDiscountValue,
    required this.startTime,
    required this.endTime,
    required this.quantity,
    required this.usedQuantity,
    required this.isDeleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'content': content,
      'imgUrl': imgUrl,
      'type': type.toPromotionString(),
      'minimumOrderValue': minimumOrderValue,
      'maximumDiscountValue': maximumDiscountValue,
      'startTime': startTime,
      'endTime': endTime,
      'quantity': quantity,
      'usedQuantity': usedQuantity,
      'isDeleted': isDeleted,
    };
  }

  factory Promotion.fromMap(Map<String, dynamic> map) {
    switch ((map['type'] as String).toPromotion()) {
      case PromotionType.freeShipping:
        return FreeShippingPromotion.fromMap(map);
      case PromotionType.percentage:
        return PercentagePromotion.fromMap(map);
      case PromotionType.fixedAmount:
        return FixedAmountPromotion.fromMap(map);
      default:
        return FreeShippingPromotion.fromMap(map);
    }
  }

  factory Promotion.create({
    required PromotionType type,
    required String id,
    required String code,
    required String content,
    double? minimumOrderValue,
    double? maximumDiscountValue,
    required String imgUrl,
    required DateTime startTime,
    required DateTime endTime,
    required int? quantity,
    required int usedQuantity,
    required double
        discountAmount, // represent for percentage or fixed amount and 0 for free shipping
    required bool isDeleted,
  }) {
    switch (type) {
      case PromotionType.freeShipping:
        return FreeShippingPromotion(
          id: id,
          code: code,
          content: content,
          imgUrl: imgUrl,
          type: type,
          maximumDiscountValue: maximumDiscountValue,
          minimumOrderValue: minimumOrderValue,
          startTime: startTime,
          endTime: endTime,
          quantity: quantity,
          usedQuantity: usedQuantity,
          isDeleted: isDeleted,
        );
      case PromotionType.percentage:
        return PercentagePromotion(
          id: id,
          code: code,
          content: content,
          imgUrl: imgUrl,
          type: type,
          maximumDiscountValue: maximumDiscountValue,
          minimumOrderValue: minimumOrderValue,
          startTime: startTime,
          endTime: endTime,
          quantity: quantity,
          usedQuantity: usedQuantity,
          percentage: discountAmount.toInt(),
          isDeleted: isDeleted,
        );
      case PromotionType.fixedAmount:
        return FixedAmountPromotion(
          id: id,
          code: code,
          content: content,
          imgUrl: imgUrl,
          type: type,
          maximumDiscountValue: maximumDiscountValue,
          minimumOrderValue: minimumOrderValue,
          startTime: startTime,
          endTime: endTime,
          quantity: quantity,
          usedQuantity: usedQuantity,
          amount: discountAmount.toDouble(),
          isDeleted: isDeleted,
        );
      default:
        return FreeShippingPromotion(
          id: id,
          code: code,
          content: content,
          imgUrl: imgUrl,
          type: type,
          maximumDiscountValue: maximumDiscountValue,
          minimumOrderValue: minimumOrderValue,
          startTime: startTime,
          endTime: endTime,
          quantity: quantity,
          usedQuantity: usedQuantity,
          isDeleted: isDeleted,
        );
    }
  }

  String toJson() => json.encode(toMap());

  factory Promotion.fromJson(String source) =>
      Promotion.fromMap(json.decode(source) as Map<String, dynamic>);

  Promotion copyWith({
    String? id,
    String? code,
    String? content,
    String? imgUrl,
    PromotionType? type,
    double? minimumOrderValue,
    double? maximumDiscountValue,
    DateTime? startTime,
    DateTime? endTime,
    int? quantity,
    int? usedQuantity,
    bool? isDeleted,
  }) {
    return Promotion(
      id: id ?? this.id,
      code: code ?? this.code,
      content: content ?? this.content,
      imgUrl: imgUrl ?? this.imgUrl,
      type: type ?? this.type,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      maximumDiscountValue: maximumDiscountValue ?? this.maximumDiscountValue,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      quantity: quantity ?? this.quantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  double get amount => 0;
  String get amountString => "";
}

class FreeShippingPromotion extends Promotion {
  FreeShippingPromotion({
    required super.id,
    required super.code,
    required super.content,
    required super.imgUrl,
    required super.type,
    super.minimumOrderValue,
    super.maximumDiscountValue,
    required super.startTime,
    required super.endTime,
    required super.quantity,
    required super.usedQuantity,
    required super.isDeleted,
  });

  factory FreeShippingPromotion.fromMap(Map<String, dynamic> map) {
    return FreeShippingPromotion(
      id: map['id'] as String,
      code: map['code'] as String,
      content: map['content'] as String,
      imgUrl: map['imgUrl'] as String,
      type: (map['type'] as String).toPromotion(),
      minimumOrderValue: map['minimumOrderValue']?.toDouble(),
      maximumDiscountValue: map['maximumDiscountValue']?.toDouble(),
      startTime: map['startTime'].toDate(),
      endTime: map['endTime'].toDate(),
      quantity: map['quantity'] ?? 0,
      usedQuantity: map['usedQuantity'] ?? 0,
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  factory FreeShippingPromotion.fromJson(String source) =>
      FreeShippingPromotion.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String get amountString => "0";

  @override
  double get amount => 0;
}

class PercentagePromotion extends Promotion {
  final int percentage;

  PercentagePromotion({
    required super.id,
    required super.code,
    required super.content,
    required super.imgUrl,
    required super.type,
    super.minimumOrderValue,
    super.maximumDiscountValue,
    required super.startTime,
    required super.endTime,
    required super.quantity,
    required super.usedQuantity,
    required super.isDeleted,
    required this.percentage,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'content': content,
      'imgUrl': imgUrl,
      'type': type.toPromotionString(),
      'minimumOrderValue': minimumOrderValue,
      'maximumDiscountValue': maximumDiscountValue,
      'startTime': startTime,
      'endTime': endTime,
      'quantity': quantity,
      'usedQuantity': usedQuantity,
      'isDeleted': isDeleted,
      'percentage': percentage,
    };
  }

  factory PercentagePromotion.fromMap(Map<String, dynamic> map) {
    return PercentagePromotion(
      id: map['id'] as String,
      code: map['code'] as String,
      content: map['content'] as String,
      imgUrl: map['imgUrl'] as String,
      type: (map['type'] as String).toPromotion(),
      minimumOrderValue: map['minimumOrderValue']?.toDouble(),
      maximumDiscountValue: map['maximumDiscountValue']?.toDouble(),
      startTime: map['startTime'].toDate(),
      endTime: map['endTime'].toDate(),
      quantity: map['quantity'] ?? 0,
      usedQuantity: map['usedQuantity'] ?? 0,
      isDeleted: map['isDeleted'] ?? false,
      percentage: map['percentage'] as int,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PercentagePromotion.fromJson(String source) =>
      PercentagePromotion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String get amountString => "$percentage%";

  @override
  double get amount => percentage.toDouble();

  @override
  PercentagePromotion copyWith({
    int? percentage,
    String? id,
    String? code,
    String? content,
    String? imgUrl,
    PromotionType? type,
    double? minimumOrderValue,
    double? maximumDiscountValue,
    DateTime? startTime,
    DateTime? endTime,
    int? quantity,
    int? usedQuantity,
    bool? isDeleted,
  }) {
    return PercentagePromotion(
      percentage: percentage ?? this.percentage,
      id: id ?? this.id,
      code: code ?? this.code,
      content: content ?? this.content,
      imgUrl: imgUrl ?? this.imgUrl,
      type: type ?? this.type,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      maximumDiscountValue: maximumDiscountValue ?? this.maximumDiscountValue,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      quantity: quantity ?? this.quantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class FixedAmountPromotion extends Promotion {
  @override
  final double amount;

  FixedAmountPromotion(
      {required super.id,
      required super.code,
      required super.content,
      required super.imgUrl,
      required super.type,
      super.maximumDiscountValue,
      super.minimumOrderValue,
      required super.startTime,
      required super.endTime,
      required super.quantity,
      required super.usedQuantity,
      required super.isDeleted,
      required this.amount});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'content': content,
      'imgUrl': imgUrl,
      'type': type.toPromotionString(),
      'minimumOrderValue': minimumOrderValue,
      'maximumDiscountValue': maximumDiscountValue,
      'startTime': startTime,
      'endTime': endTime,
      'quantity': quantity,
      'usedQuantity': usedQuantity,
      'isDeleted': isDeleted,
      'amount': amount,
    };
  }

  factory FixedAmountPromotion.fromMap(Map<String, dynamic> map) {
    return FixedAmountPromotion(
      id: map['id'] as String,
      code: map['code'] as String,
      content: map['content'] as String,
      imgUrl: map['imgUrl'] as String,
      type: (map['type'] as String).toPromotion(),
      minimumOrderValue: map['minimumOrderValue']?.toDouble(),
      maximumDiscountValue: map['maximumDiscountValue']?.toDouble(),
      startTime: map['startTime'].toDate(),
      endTime: map['endTime'].toDate(),
      quantity: map['quantity'] ?? 0,
      usedQuantity: map['usedQuantity'] ?? 0,
      isDeleted: map['isDeleted'] ?? false,
      amount: map['amount'].toDouble(),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory FixedAmountPromotion.fromJson(String source) =>
      FixedAmountPromotion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String get amountString => amount.toPriceString();

  @override
  FixedAmountPromotion copyWith({
    double? amount,
    String? id,
    String? code,
    String? content,
    String? imgUrl,
    PromotionType? type,
    double? minimumOrderValue,
    double? maximumDiscountValue,
    DateTime? startTime,
    DateTime? endTime,
    int? quantity,
    int? usedQuantity,
    bool? isDeleted,
  }) {
    return FixedAmountPromotion(
      amount: amount ?? this.amount,
      id: id ?? this.id,
      code: code ?? this.code,
      content: content ?? this.content,
      imgUrl: imgUrl ?? this.imgUrl,
      type: type ?? this.type,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      maximumDiscountValue: maximumDiscountValue ?? this.maximumDiscountValue,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      quantity: quantity ?? this.quantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
