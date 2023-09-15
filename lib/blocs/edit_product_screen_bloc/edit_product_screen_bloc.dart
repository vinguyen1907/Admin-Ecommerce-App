import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:admin_ecommerce_app/utils/image_picker_utils.dart';
import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_product_screen_event.dart';
part 'edit_product_screen_state.dart';

class EditProductScreenBloc
    extends Bloc<EditProductScreenEvent, EditProductScreenState> {
  EditProductScreenBloc()
      : super(const EditProductScreenInitial(
            categories: null, categorySelected: null, imageSelected: null)) {
    on<LoadEditProductScreen>(_onLoadEditProductScreen);
    on<ChangeImage>(_onChangeImage);
    on<ChangeCategory>(_onChangeCategory);
    on<Submit>(_onSubmit);
  }

  FutureOr<void> _onLoadEditProductScreen(
      LoadEditProductScreen event, Emitter<EditProductScreenState> emit) async {
    try {
      emit(const EditProductScreenLoading(
          categories: null, categorySelected: null, imageSelected: null));
      List<Category> categories =
          await CategoryRepository().fetchCategoriesWithoutAll();
      Category categorySelected = categories
          .where((element) => element.id == event.product.categoryId)
          .first;
      final dio = Dio();
      final Uint8List image = (await dio.get(event.product.imgUrl,
              options: Options(responseType: ResponseType.bytes)))
          .data as Uint8List;
      emit(EditProductScreenLoaded(
          categories: categories,
          categorySelected: categorySelected,
          imageSelected: image));
    } catch (e) {}
  }

  FutureOr<void> _onChangeImage(
      ChangeImage event, Emitter<EditProductScreenState> emit) async {
    try {
      final image = await ImagePickerUtils.openFilePicker(event.context);
      emit(EditProductScreenLoaded(
          categories: state.categories,
          categorySelected: state.categorySelected,
          imageSelected: image!));
    } catch (e) {}
  }

  FutureOr<void> _onChangeCategory(
      ChangeCategory event, Emitter<EditProductScreenState> emit) {
    emit(EditProductScreenLoaded(
        categories: state.categories,
        categorySelected: event.category,
        imageSelected: state.imageSelected));
  }

  FutureOr<void> _onSubmit(
      Submit event, Emitter<EditProductScreenState> emit) async {
    try {
      await ProductRepository().updateProduct(
          image: event.image,
          name: event.name,
          category: event.category,
          brand: event.brand,
          price: double.parse(event.price),
          description: event.description,
          id: event.id);
    } catch (e) {}
  }
}
