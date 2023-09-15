// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double averageRating;
  final int reviewCount;
  final String imgUrl;
  final int soldCount;
  final int stockCount;
  final DateTime createdAt;

  const Product(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.brand,
      required this.description,
      required this.price,
      required this.averageRating,
      required this.reviewCount,
      required this.imgUrl,
      required this.soldCount,
      required this.stockCount,
      required this.createdAt});

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['categoryId'],
      name: json['name'],
      brand: json['brand'],
      description: json['description'],
      price: json['price'].toDouble(),
      averageRating: json['averageRating'].toDouble(),
      reviewCount: json['reviewCount'],
      imgUrl: json['imgUrl'],
      soldCount: json['soldCount'],
      stockCount: json['stockCount'],
      createdAt: json['createdAt'].toDate(),
    );
  }

  @override
  List<Object?> get props => [id, name, price, brand];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'brand': brand,
      'description': description,
      'price': price,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'imgUrl': imgUrl,
      'soldCount': soldCount,
      'stockCount': stockCount,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
