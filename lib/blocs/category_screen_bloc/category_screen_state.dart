part of 'category_screen_bloc.dart';

sealed class CategoryScreenState extends Equatable {
  const CategoryScreenState({
    required this.categories,
    required this.firstDocument,
    required this.lastDocument,
    required this.query,
    required this.categoriesCount,
    required this.currentPageIndex,
  });
  final List<Category> categories;
  final DocumentSnapshot? firstDocument;
  final DocumentSnapshot? lastDocument;
  final String? query;
  final int categoriesCount;
  final int currentPageIndex;

  int get pagesCount =>
      (categoriesCount / AppConstants.numberItemsPerProductPage).ceil();
  @override
  List<Object?> get props => [
        categories,
        firstDocument,
        lastDocument,
        query,
        categoriesCount,
        currentPageIndex
      ];
}

class CategoryScreenInitial extends CategoryScreenState {
  const CategoryScreenInitial(
      {required super.categories,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.categoriesCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}

class CategoryScreenLoading extends CategoryScreenState {
  const CategoryScreenLoading(
      {required super.categories,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.categoriesCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}

class LoadingCategories extends CategoryScreenState {
  const LoadingCategories(
      {required super.categories,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.categoriesCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}

class CategoryScreenLoaded extends CategoryScreenState {
  const CategoryScreenLoaded(
      {required super.categories,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.categoriesCount,
      required super.currentPageIndex});

  CategoryScreenLoaded copyWith(
      {List<Category>? categories,
      DocumentSnapshot? firstDocument,
      DocumentSnapshot? lastDocument,
      int? categoriesCount,
      int? currentPageIndex,
      String? query}) {
    return CategoryScreenLoaded(
        categories: categories ?? this.categories,
        firstDocument: firstDocument ?? this.firstDocument,
        lastDocument: lastDocument ?? this.lastDocument,
        categoriesCount: categoriesCount ?? this.categoriesCount,
        currentPageIndex: currentPageIndex ?? this.currentPageIndex,
        query: query ?? this.query);
  }
}

class CategoryScreenError extends CategoryScreenState {
  final String message;

  const CategoryScreenError(this.message,
      {required super.categories,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.categoriesCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}

class SearchingCategory extends CategoryScreenState {
  const SearchingCategory(
      {required super.categories,
      required super.firstDocument,
      required super.lastDocument,
      required super.query,
      required super.categoriesCount,
      required super.currentPageIndex});

  @override
  List<Object> get props => [];
}
