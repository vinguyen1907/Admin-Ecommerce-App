import 'dart:developer';

import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/models/product_detail.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_product_stock_screen_event.dart';
part 'add_product_stock_screen_state.dart';

class AddProductStockScreenBloc
    extends Bloc<AddProductStockScreenEvent, AddProductStockScreenState> {
  AddProductStockScreenBloc()
      : super(const AddProductStockScreenInitial(
            productDetails: [], productDetailSelected: null)) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<ChangeProductDetail>(_onChangeProductDetail);
    on<Import>(_onImport);
  }

  Future<void> _onLoadProductDetails(LoadProductDetails event,
      Emitter<AddProductStockScreenState> emit) async {
    emit(AddProductStockScreenLoading(
        productDetails: state.productDetails,
        productDetailSelected: state.productDetailSelected));
    List<ProductDetail> productDetails = await ProductRepository()
        .getProductDetails(productId: event.product.id);
    ProductDetail productDetailSelected = productDetails.first;
    emit(AddProductStockScreenLoaded(
        productDetails: productDetails,
        productDetailSelected: productDetailSelected));
  }

  Future<void> _onChangeProductDetail(ChangeProductDetail event,
      Emitter<AddProductStockScreenState> emit) async {
    emit(AddProductStockScreenLoaded(
        productDetails: state.productDetails,
        productDetailSelected: event.productDetail));
  }

  Future<void> _onImport(
      Import event, Emitter<AddProductStockScreenState> emit) async {
    try {
      emit(Importing(
          productDetails: state.productDetails,
          productDetailSelected: state.productDetailSelected));
      await ProductRepository().importProductDetail(
          productDetail: state.productDetailSelected!,
          product: event.product,
          quantity: int.parse(event.quantity));
      emit(ImportSuccessful(
          productDetails: state.productDetails,
          productDetailSelected: state.productDetailSelected));
    } catch (e) {
      log(e.toString());
    }
  }
}
