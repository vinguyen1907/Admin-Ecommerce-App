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
  final List<Product> originalList;
  final List<Product> queryList;
  final List<Product> products;
  final List<Category> categories;
  final Category categorySelected;
  final int numberPages;
  final int pageSelected;

  const ProductScreenLoaded({
    required this.originalList,
    required this.queryList,
    required this.products,
    required this.categories,
    required this.categorySelected,
    required this.numberPages,
    required this.pageSelected,
  });

  @override
  List<Object> get props => [
        products,
        categories,
        categorySelected,
        pageSelected,
        numberPages,
        originalList,
        queryList
      ];

  ProductScreenLoaded copyWith({
    List<Product>? originalList,
    List<Product>? queryList,
    List<Product>? products,
    List<Category>? categories,
    Category? categorySelected,
    int? numberPages,
    int? pageSelected,
  }) {
    return ProductScreenLoaded(
      originalList: originalList ?? this.originalList,
      queryList: queryList ?? this.queryList,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      categorySelected: categorySelected ?? this.categorySelected,
      numberPages: numberPages ?? this.numberPages,
      pageSelected: pageSelected ?? this.pageSelected,
    );
  }
}

class ProductScreenError extends ProductScreenState {
  final String message;

  const ProductScreenError({required this.message});
  @override
  List<Object> get props => [];
}
