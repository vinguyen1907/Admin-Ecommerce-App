import 'dart:async';

import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_screen_event.dart';
part 'product_screen_state.dart';

class ProductScreenBloc extends Bloc<ProductScreenEvent, ProductScreenState> {
  ProductScreenBloc() : super(ProductScreenInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<ChangePage>(_onChangePage);
    on<ChangeCategory>(_onChangeCategory);
    on<SearchProduct>(_onSearchProduct);
  }
  // List<Product> originalList = [];
  // List<Product> queryList = [];
  _onLoadProducts(LoadProducts event, Emitter<ProductScreenState> emit) async {
    emit(ProductScreenLoading());
    List<Category> categories = await CategoryRepository().fetchCategories();
    Category categorySelected = categories.first;
    List<Product> products =
        await ProductRepository().fetchProductInCategory(categorySelected);
    List<Product> originalList = List.from(products);
    List<Product> queryList = List.from(products);
    int numberPages = (queryList.length / 8).ceil();
    int pageSelected = 0;
    final startIndex = pageSelected * 8;
    int endIndex;
    if ((pageSelected + 1) * 8 > queryList.length) {
      endIndex = queryList.length;
    } else {
      endIndex = (pageSelected + 1) * 8;
    }
    List<Product> handleProducts = queryList.sublist(startIndex, endIndex);
    emit(ProductScreenLoaded(
        originalList: originalList,
        queryList: queryList,
        products: handleProducts,
        categories: categories,
        categorySelected: categorySelected,
        numberPages: numberPages,
        pageSelected: pageSelected));
  }

  _onSearchProduct(SearchProduct event, Emitter<ProductScreenState> emit) {
    final currentState = state as ProductScreenLoaded;
    final String query = event.query;
    final List<Product> products = List.from(currentState.originalList);
    List<Product> queryProducts;
    if (query.isNotEmpty) {
      queryProducts = products
          .where((element) => element.name
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase().trim()))
          .toList();
    } else {
      queryProducts = products;
    }
    List<Product> handleProducts;
    int pageSelected = 0;
    int numberPages;
    if (queryProducts.isEmpty) {
      handleProducts = [];
      numberPages = 1;
    } else {
      numberPages = (queryProducts.length / 8).ceil();
      final startIndex = pageSelected * 8;
      int endIndex;
      if ((pageSelected + 1) * 8 > queryProducts.length) {
        endIndex = queryProducts.length;
      } else {
        endIndex = (pageSelected + 1) * 8;
      }
      handleProducts = queryProducts.sublist(startIndex, endIndex);
    }
    emit(currentState.copyWith(
        queryList: queryProducts,
        products: handleProducts,
        numberPages: numberPages,
        pageSelected: pageSelected));
  }

  FutureOr<void> _onChangePage(
      ChangePage event, Emitter<ProductScreenState> emit) {
    final currentState = state as ProductScreenLoaded;
    final pageSelected = event.pageSelected;
    final startIndex = pageSelected * 8;
    final List<Product> products;
    products = List.from(currentState.queryList);
    int endIndex;
    if ((pageSelected + 1) * 8 > products.length) {
      endIndex = products.length;
    } else {
      endIndex = (pageSelected + 1) * 8;
    }
    List<Product> handleProducts =
        products.sublist(startIndex, endIndex).toList();
    emit(currentState.copyWith(
        products: handleProducts, pageSelected: pageSelected));
  }

  FutureOr<void> _onChangeCategory(
      ChangeCategory event, Emitter<ProductScreenState> emit) async {
    emit(ProductScreenLoading());
    List<Category> categories = await CategoryRepository().fetchCategories();
    Category categorySelected = event.categorySelected;
    List<Product> products = await ProductRepository()
        .fetchProductInCategory(event.categorySelected);
    List<Product> originalList = List.from(products);
    List<Product> queryList = List.from(products);
    int numberPages = (queryList.length / 8).ceil();
    int pageSelected = 0;
    final startIndex = pageSelected * 8;
    int endIndex;
    if ((pageSelected + 1) * 8 > queryList.length) {
      endIndex = queryList.length;
    } else {
      endIndex = (pageSelected + 1) * 8;
    }
    List<Product> handleProducts = products.sublist(startIndex, endIndex);
    emit(ProductScreenLoaded(
        queryList: queryList,
        originalList: originalList,
        products: handleProducts,
        categories: categories,
        categorySelected: categorySelected,
        numberPages: numberPages,
        pageSelected: pageSelected));
  }
}
