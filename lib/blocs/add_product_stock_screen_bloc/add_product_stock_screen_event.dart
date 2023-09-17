part of 'add_product_stock_screen_bloc.dart';

abstract class AddProductStockScreenEvent extends Equatable {
  const AddProductStockScreenEvent();
}

class LoadProductDetails extends AddProductStockScreenEvent {
  const LoadProductDetails({required this.product});
  final Product product;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeProductDetail extends AddProductStockScreenEvent {
  const ChangeProductDetail({required this.productDetail});
  final ProductDetail productDetail;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Import extends AddProductStockScreenEvent {
  const Import({
    required this.quantity,
    required this.product,
  });
  final String quantity;
  final Product product;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
