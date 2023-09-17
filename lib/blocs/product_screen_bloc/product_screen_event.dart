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

class LoadPreviousPage extends ProductScreenEvent {
  const LoadPreviousPage();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadNextPage extends ProductScreenEvent {
  const LoadNextPage();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeCategory extends ProductScreenEvent {
  const ChangeCategory({required this.categorySelected});
  final Category categorySelected;
  @override
  // TODO: implement props
  List<Object?> get props => [categorySelected];
}

class DeleteProduct extends ProductScreenEvent {
  const DeleteProduct({required this.id});
  final String id;
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}


