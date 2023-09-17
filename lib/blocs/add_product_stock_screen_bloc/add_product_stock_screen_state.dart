part of 'add_product_stock_screen_bloc.dart';

sealed class AddProductStockScreenState extends Equatable {
  const AddProductStockScreenState({
    required this.productDetails,
    required this.productDetailSelected,
  });
  final List<ProductDetail> productDetails;
  final ProductDetail? productDetailSelected;

  @override
  List<Object?> get props => [
        productDetails,
        productDetailSelected,
      ];
}

class AddProductStockScreenInitial extends AddProductStockScreenState {
  const AddProductStockScreenInitial(
      {required super.productDetails, required super.productDetailSelected});

  @override
  List<Object> get props => [];
}

class AddProductStockScreenLoading extends AddProductStockScreenState {
  const AddProductStockScreenLoading(
      {required super.productDetails, required super.productDetailSelected});

  @override
  List<Object> get props => [productDetails];
}

class AddProductStockScreenLoaded extends AddProductStockScreenState {
  const AddProductStockScreenLoaded(
      {required super.productDetails, required super.productDetailSelected});

  @override
  List<Object> get props => [productDetailSelected!];
}

class Importing extends AddProductStockScreenState {
  const Importing(
      {required super.productDetails, required super.productDetailSelected});

  @override
  List<Object> get props => [productDetailSelected!];
}

class ImportSuccessful extends AddProductStockScreenState {
  const ImportSuccessful(
      {required super.productDetails, required super.productDetailSelected});

  @override
  List<Object> get props => [productDetailSelected!];
}
