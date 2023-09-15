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

class ChangeCategory extends EditProductScreenEvent {
  final Category category;
  const ChangeCategory({
    required this.category,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Submit extends EditProductScreenEvent {
  final Uint8List image;
  final String name;
  final String brand;
  final String price;
  final String description;
  final Category category;
  final String id;
  const Submit({
    required this.image,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.description,
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
