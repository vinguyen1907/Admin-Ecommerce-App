part of 'product_screen_bloc.dart';

sealed class ProductScreenState extends Equatable {
  const ProductScreenState({
    required this.products,
    required this.categories,
    required this.categorySelected,
    required this.firstDocument,
    required this.lastDocument,
    required this.query,
    required this.productsCount,
    required this.currentPageIndex,
  });
  final List<Product> products;
  final List<Category> categories;
  final Category categorySelected;
  final DocumentSnapshot? firstDocument;
  final DocumentSnapshot? lastDocument;
  final String? query;
  final int productsCount;
  final int currentPageIndex;

  int get pagesCount =>
      (productsCount / AppConstants.numberItemsPerProductPage).ceil();
  @override
  List<Object?> get props => [
        products,
        categories,
        categorySelected,
        firstDocument,
        lastDocument,
        query,
        productsCount,
        currentPageIndex
      ];
}

class ProductScreenInitial extends ProductScreenState {
  const ProductScreenInitial()
      : super(
            products: const [],
            categories: const [],
            categorySelected: AppConstants.allCategory,
            firstDocument: null,
            lastDocument: null,
            query: '',
            productsCount: 0,
            currentPageIndex: 0);

  @override
  List<Object> get props => [];
}

class ProductScreenLoading extends ProductScreenState {
  const ProductScreenLoading(
      {required super.products,
      required super.categories,
      required super.categorySelected,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.productsCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}

class LoadingProducts extends ProductScreenState {
  const LoadingProducts(
      {required super.products,
      required super.categories,
      required super.categorySelected,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.productsCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}

class ProductScreenLoaded extends ProductScreenState {
  const ProductScreenLoaded(
      {required super.products,
      required super.categories,
      required super.categorySelected,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.productsCount,
      required super.currentPageIndex});
  ProductScreenLoaded copyWith(
      {List<Product>? products,
      List<Category>? categories,
      Category? categorySelected,
      DocumentSnapshot? firstDocument,
      DocumentSnapshot? lastDocument,
      int? productsCount,
      int? currentPageIndex,
      String? query}) {
    return ProductScreenLoaded(
        products: products ?? this.products,
        categories: categories ?? this.categories,
        categorySelected: categorySelected ?? this.categorySelected,
        firstDocument: firstDocument ?? this.firstDocument,
        lastDocument: lastDocument ?? this.lastDocument,
        productsCount: productsCount ?? this.productsCount,
        currentPageIndex: currentPageIndex ?? this.currentPageIndex,
        query: query ?? this.query);
  }
}

class ProductScreenError extends ProductScreenState {
  final String message;

  const ProductScreenError(
      {required this.message,
      required super.products,
      required super.categories,
      required super.categorySelected,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.productsCount,
      required super.currentPageIndex});
  @override
  List<Object> get props => [];
}

class SearchingProduct extends ProductScreenState {
  const SearchingProduct(
      {required super.products,
      required super.categories,
      required super.categorySelected,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.productsCount,
      required super.currentPageIndex});
  @override
  List<Object> get props => [];
}
