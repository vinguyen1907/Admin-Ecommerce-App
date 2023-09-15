import 'dart:async';
import 'dart:developer';

import 'package:admin_ecommerce_app/extensions/string_extensions.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_product_screen_event.dart';
part 'add_product_screen_state.dart';

class AddProductScreenBloc
    extends Bloc<AddProductScreenEvent, AddProductScreenState> {
  AddProductScreenBloc()
      : super(const AddProductScreenInitial(
          categories: null,
          categorySelected: null,
        )) {
    on<LoadCategories>(_onLoadCategories);
    on<ChangeCategorySelected>(_onChangeCategorySelected);
    on<AddImage>(_onAddImage);
    on<Submit>(_onSubmit);
  }

  FutureOr<void> _onLoadCategories(
      LoadCategories event, Emitter<AddProductScreenState> emit) async {
    try {
      emit(const AddProductScreenLoading(
        categories: null,
        categorySelected: null,
      ));
      List<Category> categories =
          await CategoryRepository().fetchCategoriesWithoutAll();
      Category categorySelected = categories.first;
      emit(AddProductScreenLoaded(
        categories: categories,
        categorySelected: categorySelected,
      ));
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _onChangeCategorySelected(
      ChangeCategorySelected event, Emitter<AddProductScreenState> emit) {
    emit(AddProductScreenLoaded(
      categories: state.categories,
      categorySelected: event.categorySelected,
    ));
  }

  FutureOr<void> _onAddImage(
      AddImage event, Emitter<AddProductScreenState> emit) {
    emit(AddProductScreenLoaded(
      categories: state.categories,
      categorySelected: state.categorySelected,
    ));
  }

  FutureOr<void> _onSubmit(
      Submit event, Emitter<AddProductScreenState> emit) async {
    emit(Submitting(
        categories: state.categories,
        categorySelected: state.categorySelected));
    await ProductRepository().addProduct(
        name: event.name,
        brand: event.brand,
        price: event.price.toPrice(),
        description: event.description,
        category: state.categorySelected!,
        image: event.image);
    emit(SubmitSuccessful(
        categories: state.categories,
        categorySelected: state.categories!.first));
  }
}
