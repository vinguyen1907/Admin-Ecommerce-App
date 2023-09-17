import 'package:equatable/equatable.dart';

class ProductDetail extends Equatable {
  final String? size;
  final String? color;
  final int stock;

  ProductDetail({
    required this.size,
    required this.color,
    required this.stock,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      size: json['size'].toString(),
      color: json['color'],
      stock: json['stock'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [size, color];
}
