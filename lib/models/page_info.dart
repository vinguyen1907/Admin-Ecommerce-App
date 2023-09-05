import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PageInfo extends Equatable {
  final Category categorySelected;
  final DocumentSnapshot firstDocument;
  final DocumentSnapshot lastDocument;
  final List<Product> products;
  final int numberPages;

  const PageInfo(
      {required this.categorySelected,
      required this.numberPages,
      required this.firstDocument,
      required this.lastDocument,
      required this.products});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [categorySelected, firstDocument, lastDocument, products, numberPages];
}
