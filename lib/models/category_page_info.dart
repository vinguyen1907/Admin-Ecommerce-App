import 'package:admin_ecommerce_app/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryPageInfo extends Equatable {
  final DocumentSnapshot? firstDocument;
  final DocumentSnapshot? lastDocument;
  final List<Category> categories;
  final int categoriesCount;

  const CategoryPageInfo(
      {required this.categoriesCount,
      required this.firstDocument,
      required this.lastDocument,
      required this.categories});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [categories, firstDocument, lastDocument, categoriesCount];
}
