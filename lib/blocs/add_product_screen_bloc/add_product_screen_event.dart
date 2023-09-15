part of 'add_product_screen_bloc.dart';

abstract class AddProductScreenEvent extends Equatable {
  const AddProductScreenEvent();
}

class LoadCategories extends AddProductScreenEvent {
  const LoadCategories();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChangeCategorySelected extends AddProductScreenEvent {
  const ChangeCategorySelected({required this.categorySelected});
  final Category categorySelected;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AddImage extends AddProductScreenEvent {
  const AddImage({required this.imageSelected});
  final Uint8List? imageSelected;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Submit extends AddProductScreenEvent {
  const Submit(
      {required this.image,
      required this.name,
      required this.brand,
      required this.price,
      required this.description});
  final Uint8List image;
  final String name;
  final String brand;
  final String price;
  final String description;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
