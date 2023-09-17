part of 'category_screen_bloc.dart';

abstract class CategoryScreenEvent extends Equatable {
  const CategoryScreenEvent();
}

class LoadCategories extends CategoryScreenEvent {
  const LoadCategories();
  @override
  List<Object?> get props => [];
}

class SearchCategory extends CategoryScreenEvent {
  const SearchCategory({required this.query});
  final String query;
  @override
  // TODO: implement props
  List<Object?> get props => [query];
}

class LoadPreviousPage extends CategoryScreenEvent {
  const LoadPreviousPage();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadNextPage extends CategoryScreenEvent {
  const LoadNextPage();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteCategory extends CategoryScreenEvent {
  const DeleteCategory({required this.id});
  final String id;
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
