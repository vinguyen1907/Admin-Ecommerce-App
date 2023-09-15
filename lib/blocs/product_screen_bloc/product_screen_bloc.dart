import 'dart:async';

import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/page_info.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_screen_event.dart';
part 'product_screen_state.dart';

class ProductScreenBloc extends Bloc<ProductScreenEvent, ProductScreenState> {
  ProductScreenBloc() : super(const ProductScreenInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadNextPage>(_onLoadNextPage);
    on<LoadPreviousPage>(_onLoadPreviousPage);
    on<ChangeCategory>(_onChangeCategory);
    on<SearchProduct>(_onSearchProduct);
  }

  _onLoadProducts(LoadProducts event, Emitter<ProductScreenState> emit) async {
    emit(ProductScreenLoading(
        products: state.products,
        categories: state.categories,
        categorySelected: state.categorySelected,
        firstDocument: state.firstDocument,
        lastDocument: state.lastDocument,
        query: state.query,
        productsCount: state.productsCount,
        currentPageIndex: state.currentPageIndex));
    List<Category> categories = await CategoryRepository().fetchCategories();
    PageInfo pageInfo =
        await ProductRepository().getPageInfo(categories.first, '');
    emit(ProductScreenLoaded(
        products: pageInfo.products,
        categories: categories,
        categorySelected: categories.first,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        query: '',
        productsCount: pageInfo.productsCount,
        currentPageIndex: 0));
  }

  _onSearchProduct(
      SearchProduct event, Emitter<ProductScreenState> emit) async {
    emit(SearchingProduct(
        products: state.products,
        categories: state.categories,
        categorySelected: state.categorySelected,
        firstDocument: state.firstDocument,
        lastDocument: state.lastDocument,
        query: event.query,
        productsCount: state.productsCount,
        currentPageIndex: state.currentPageIndex));
    PageInfo pageInfo = await ProductRepository()
        .getPageInfo(state.categorySelected, event.query);
    emit(ProductScreenLoaded(
        products: pageInfo.products,
        categories: state.categories,
        categorySelected: state.categorySelected,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        query: state.query,
        productsCount: pageInfo.productsCount,
        currentPageIndex: 0));
  }

  FutureOr<void> _onLoadNextPage(
      LoadNextPage event, Emitter<ProductScreenState> emit) async {
    if ((state.currentPageIndex + 1) * AppConstants.numberItemsPerProductPage <
        state.productsCount) {
      emit(LoadingProducts(
          products: state.products,
          categories: state.categories,
          categorySelected: state.categorySelected,
          firstDocument: state.firstDocument,
          lastDocument: state.lastDocument,
          query: state.query,
          productsCount: state.productsCount,
          currentPageIndex: state.currentPageIndex));
      final int newPageIndex = state.currentPageIndex + 1;
      PageInfo pageInfo = await ProductRepository().loadNextPage(
          state.categorySelected, state.query!, state.lastDocument!);
      emit(ProductScreenLoaded(
          products: pageInfo.products,
          categories: state.categories,
          categorySelected: state.categorySelected,
          firstDocument: pageInfo.firstDocument,
          lastDocument: pageInfo.lastDocument,
          query: state.query,
          productsCount: state.productsCount,
          currentPageIndex: newPageIndex));
    }
  }

  FutureOr<void> _onChangeCategory(
      ChangeCategory event, Emitter<ProductScreenState> emit) async {
    emit(LoadingProducts(
        products: state.products,
        categories: state.categories,
        categorySelected: state.categorySelected,
        firstDocument: state.firstDocument,
        lastDocument: state.lastDocument,
        query: state.query,
        productsCount: state.productsCount,
        currentPageIndex: state.currentPageIndex));
    Category categorySelected = event.categorySelected;
    PageInfo pageInfo =
        await ProductRepository().getPageInfo(categorySelected, '');
    emit((ProductScreenLoaded(
        products: pageInfo.products,
        categories: state.categories,
        categorySelected: categorySelected,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        query: '',
        productsCount: pageInfo.productsCount,
        currentPageIndex: 0)));
  }

  FutureOr<void> _onLoadPreviousPage(
      LoadPreviousPage event, Emitter<ProductScreenState> emit) async {
    if ((state.currentPageIndex - 1) >= 0) {
      emit(LoadingProducts(
          products: state.products,
          categories: state.categories,
          categorySelected: state.categorySelected,
          firstDocument: state.firstDocument,
          lastDocument: state.lastDocument,
          query: state.query,
          productsCount: state.productsCount,
          currentPageIndex: state.currentPageIndex));
      final int newPageIndex = state.currentPageIndex - 1;
      PageInfo pageInfo = await ProductRepository().loadPreviousPage(
          state.categorySelected, state.query!, state.firstDocument!);
      emit(ProductScreenLoaded(
          products: pageInfo.products,
          categories: state.categories,
          categorySelected: state.categorySelected,
          firstDocument: pageInfo.firstDocument,
          lastDocument: pageInfo.lastDocument,
          query: state.query,
          productsCount: state.productsCount,
          currentPageIndex: newPageIndex));
    }
  }
}
