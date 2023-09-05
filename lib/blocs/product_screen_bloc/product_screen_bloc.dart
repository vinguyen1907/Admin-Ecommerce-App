import 'dart:async';

import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/page_info.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_screen_event.dart';
part 'product_screen_state.dart';

class ProductScreenBloc extends Bloc<ProductScreenEvent, ProductScreenState> {
  ProductScreenBloc() : super(ProductScreenInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadNextPage>(_onLoadNextPage);
    on<ChangeCategory>(_onChangeCategory);
    on<SearchProduct>(_onSearchProduct);
  }

  _onLoadProducts(LoadProducts event, Emitter<ProductScreenState> emit) async {
    emit(ProductScreenLoading());
    Category allCategory =
        const Category(id: '', name: 'All', imgUrl: '', productCount: 0);
    List<Category> categories = [allCategory];
    categories.addAll(await CategoryRepository().fetchCategories());
    PageInfo pageInfo = await _getPageInfo(allCategory, '');
    int pageSelected = 0;
    emit(ProductScreenLoaded(
        numberPages: pageInfo.numberPages,
        pageSelected: pageSelected,
        products: pageInfo.products,
        query: '',
        categories: categories,
        categorySelected: allCategory,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument));
  }

  _onSearchProduct(
      SearchProduct event, Emitter<ProductScreenState> emit) async {
    final currentState = state as ProductScreenLoaded;
    String query = event.query;
    PageInfo pageInfo =
        await _getPageInfo(currentState.categorySelected, query);
    emit(currentState.copyWith(
        query: '',
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        products: pageInfo.products));
  }

  FutureOr<void> _onLoadNextPage(
      LoadNextPage event, Emitter<ProductScreenState> emit) {}

  FutureOr<void> _onChangeCategory(
      ChangeCategory event, Emitter<ProductScreenState> emit) async {
    final currentState = state as ProductScreenLoaded;
    Category categorySelected = event.categorySelected;
    PageInfo pageInfo = await _getPageInfo(categorySelected, '');
    emit(currentState.copyWith(
        query: '',
        categorySelected: categorySelected,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        products: pageInfo.products));
  }

  Future<PageInfo> _getPageInfo(Category category, String query) async {
    List<Product> products = [];
    DocumentSnapshot? firstDocument;
    DocumentSnapshot? lastDocument;
    int? numberPages;
    if (query.isNotEmpty) {
      if (category.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef
            .where('keyword', arrayContains: query)
            .count()
            .get();
        numberPages = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .limit(8)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            firstDocument = value.docs.first;
            lastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else if (category.name == 'New Arrivals') {
        await productsRef
            .orderBy('createdAt', descending: true)
            .where('keyword', arrayContains: query)
            .limit(8)
            .get()
            .then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .where('keyword', arrayContains: query)
            .limit(8)
            .get()
            .then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    } else {
      if (category.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef.count().get();
        numberPages = temp.count;
        await productsRef.limit(8).get().then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else if (category.name == 'New Arrivals') {
        await productsRef
            .orderBy('createdAt', descending: true)
            .limit(8)
            .get()
            .then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .limit(8)
            .get()
            .then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    }
    PageInfo pageInfo = PageInfo(
        numberPages: numberPages!,
        categorySelected: category,
        firstDocument: firstDocument!,
        lastDocument: lastDocument!,
        products: products);
    return pageInfo;
  }
}
