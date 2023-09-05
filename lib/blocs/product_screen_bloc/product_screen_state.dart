part of 'product_screen_bloc.dart';

abstract class ProductScreenState extends Equatable {
  const ProductScreenState();
}

class ProductScreenInitial extends ProductScreenState {
  @override
  List<Object> get props => [];
}

class ProductScreenLoading extends ProductScreenState {
  @override
  List<Object> get props => [];
}

class ProductScreenLoaded extends ProductScreenState {
  final List<Product> products;
  final List<Category> categories;
  final Category categorySelected;
  final DocumentSnapshot firstDocument;
  final DocumentSnapshot lastDocument;
  final String query;
  final int numberPages;
  final int pageSelected;

  const ProductScreenLoaded(
      {required this.products,
      required this.categories,
      required this.numberPages,
      required this.pageSelected,
      required this.categorySelected,
      required this.firstDocument,
      required this.lastDocument,
      required this.query});

  @override
  List<Object> get props => [
        products,
        categories,
        categorySelected,
        firstDocument,
        lastDocument,
        query,
        numberPages,
        pageSelected
      ];

  ProductScreenLoaded copyWith(
      {List<Product>? products,
      List<Category>? categories,
      Category? categorySelected,
      DocumentSnapshot? firstDocument,
      DocumentSnapshot? lastDocument,
      int? numberPages,
      int? pageSelected,
      String? query}) {
    return ProductScreenLoaded(
        products: products ?? this.products,
        categories: categories ?? this.categories,
        categorySelected: categorySelected ?? this.categorySelected,
        firstDocument: firstDocument ?? this.firstDocument,
        lastDocument: lastDocument ?? this.lastDocument,
        numberPages: numberPages ?? this.numberPages,
        pageSelected: pageSelected ?? this.pageSelected,
        query: query ?? this.query);
  }
}

class ProductScreenError extends ProductScreenState {
  final String message;

  const ProductScreenError({required this.message});
  @override
  List<Object> get props => [];
}
