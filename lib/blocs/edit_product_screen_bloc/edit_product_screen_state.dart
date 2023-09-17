part of 'edit_product_screen_bloc.dart';

abstract class EditProductScreenState extends Equatable {
  final List<Category>? categories;
  final Category? categorySelected;
  final Uint8List? imageSelected;
  const EditProductScreenState(
      {required this.categories,
      required this.categorySelected,
      required this.imageSelected});
}

class EditProductScreenInitial extends EditProductScreenState {
  const EditProductScreenInitial(
      {required super.categories,
      required super.categorySelected,
      required super.imageSelected});

  @override
  List<Object> get props => [];
}

class EditProductScreenLoading extends EditProductScreenState {
  const EditProductScreenLoading(
      {required super.categories,
      required super.categorySelected,
      required super.imageSelected});

  @override
  List<Object> get props => [];
}

class EditProductScreenLoaded extends EditProductScreenState {
  const EditProductScreenLoaded(
      {required super.categories,
      required super.categorySelected,
      required super.imageSelected});

  @override
  List<Object> get props => [imageSelected!, categorySelected!];
}

class Updating extends EditProductScreenState {
  const Updating(
      {required super.categories,
      required super.categorySelected,
      required super.imageSelected});

  @override
  List<Object> get props => [imageSelected!, categorySelected!];
}

class UpdateSuccessful extends EditProductScreenState {
  const UpdateSuccessful(
      {required super.categories,
      required super.categorySelected,
      required super.imageSelected});

  @override
  List<Object> get props => [imageSelected!, categorySelected!];
}
