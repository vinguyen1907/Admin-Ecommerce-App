part of 'product_screen_bloc.dart';

abstract class ProductScreenEvent extends Equatable {
  const ProductScreenEvent();
}

class LoadProducts extends ProductScreenEvent {
  const LoadProducts();
  @override
  List<Object?> get props => [];
}

class SearchProduct extends ProductScreenEvent {
  const SearchProduct({required this.query});
  final String query;
  @override
  // TODO: implement props
  List<Object?> get props => [query];
}

class ChangePage extends ProductScreenEvent {
  const ChangePage({required this.pageSelected});
  final int pageSelected;
  @override
  // TODO: implement props
  List<Object?> get props => [pageSelected];
}

class ChangeCategory extends ProductScreenEvent {
  const ChangeCategory({required this.categorySelected});
  final Category categorySelected;
  @override
  // TODO: implement props
  List<Object?> get props => [categorySelected];
}
