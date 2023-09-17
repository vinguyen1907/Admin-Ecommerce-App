part of 'edit_product_screen_bloc.dart';

abstract class EditProductScreenEvent extends Equatable {
  const EditProductScreenEvent();
}

class LoadEditProductScreen extends EditProductScreenEvent {
  final Product product;
  const LoadEditProductScreen({required this.product});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChangeImage extends EditProductScreenEvent {
  final BuildContext context;
  const ChangeImage({
    required this.context,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChangeCategoryEditProductScreen extends EditProductScreenEvent {
  final Category category;
  const ChangeCategoryEditProductScreen({
    required this.category,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Update extends EditProductScreenEvent {
  final String name;
  final String brand;
  final String price;
  final String description;
  final String id;
  const Update({
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.id
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
