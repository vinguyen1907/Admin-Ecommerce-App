part of 'add_product_screen_bloc.dart';

sealed class AddProductScreenState extends Equatable {
  final List<Category>? categories;
  final Category? categorySelected;
  const AddProductScreenState({
    required this.categories,
    required this.categorySelected,
  });
}

class AddProductScreenInitial extends AddProductScreenState {
  const AddProductScreenInitial({
    required super.categories,
    required super.categorySelected,
  });

  @override
  List<Object> get props => [];
}

class AddProductScreenLoading extends AddProductScreenState {
  const AddProductScreenLoading({
    required super.categories,
    required super.categorySelected,
  });

  @override
  List<Object> get props => [];
}

class AddProductScreenLoaded extends AddProductScreenState {
  const AddProductScreenLoaded({
    required super.categories,
    required super.categorySelected,
  });
  @override
  List<Object> get props => [categorySelected!];
}

class Submitting extends AddProductScreenState {
  const Submitting({
    required super.categories,
    required super.categorySelected,
  });
  @override
  List<Object> get props => [];
}

class SubmitSuccessful extends AddProductScreenState {
  const SubmitSuccessful({
    required super.categories,
    required super.categorySelected,
  });
  @override
  List<Object> get props => [];
}
