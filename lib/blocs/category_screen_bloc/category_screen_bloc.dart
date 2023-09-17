import 'dart:async';

import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/category_page_info.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_screen_event.dart';
part 'category_screen_state.dart';

class CategoryScreenBloc
    extends Bloc<CategoryScreenEvent, CategoryScreenState> {
  CategoryScreenBloc()
      : super(const CategoryScreenInitial(
            categories: [],
            firstDocument: null,
            lastDocument: null,
            query: '',
            categoriesCount: 0,
            currentPageIndex: 0)) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadNextPage>(_onLoadNextPage);
    on<LoadPreviousPage>(_onLoadPreviousPage);
    on<SearchCategory>(_onSearchCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  FutureOr<void> _onLoadCategories(
      CategoryScreenEvent event, Emitter<CategoryScreenState> emit) async {
    emit(CategoryScreenLoading(
        categories: state.categories,
        firstDocument: state.firstDocument,
        lastDocument: state.lastDocument,
        query: state.query,
        categoriesCount: state.categoriesCount,
        currentPageIndex: state.currentPageIndex));
    CategoryPageInfo pageInfo =
        await CategoryRepository().getCategoryPageInfo('');
    emit(CategoryScreenLoaded(
        categories: pageInfo.categories,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        query: '',
        currentPageIndex: 0,
        categoriesCount: pageInfo.categoriesCount));
  }

  FutureOr<void> _onLoadNextPage(
      LoadNextPage event, Emitter<CategoryScreenState> emit) async {
    if ((state.currentPageIndex + 1) * AppConstants.numberItemsPerProductPage <
        state.categoriesCount) {
      emit(LoadingCategories(
          categories: state.categories,
          firstDocument: state.firstDocument,
          lastDocument: state.lastDocument,
          query: state.query,
          categoriesCount: state.categoriesCount,
          currentPageIndex: state.currentPageIndex));
      final int newPageIndex = state.currentPageIndex + 1;
      CategoryPageInfo pageInfo = await CategoryRepository()
          .loadNextPage(state.query!, state.lastDocument!);
      emit(CategoryScreenLoaded(
          categories: state.categories,
          firstDocument: pageInfo.firstDocument,
          lastDocument: pageInfo.lastDocument,
          query: state.query,
          categoriesCount: state.categoriesCount,
          currentPageIndex: newPageIndex));
    }
  }

  FutureOr<void> _onLoadPreviousPage(
      LoadPreviousPage event, Emitter<CategoryScreenState> emit) async {
    if ((state.currentPageIndex - 1) >= 0) {
      emit(LoadingCategories(
          categories: state.categories,
          firstDocument: state.firstDocument,
          lastDocument: state.lastDocument,
          query: state.query,
          categoriesCount: state.categoriesCount,
          currentPageIndex: state.currentPageIndex));
      final int newPageIndex = state.currentPageIndex - 1;
      CategoryPageInfo pageInfo = await CategoryRepository()
          .loadPreviousPage(state.query!, state.firstDocument!);
      emit(CategoryScreenLoaded(
          categories: state.categories,
          firstDocument: pageInfo.firstDocument,
          lastDocument: pageInfo.lastDocument,
          query: state.query,
          categoriesCount: state.categoriesCount,
          currentPageIndex: newPageIndex));
    }
  }

  FutureOr<void> _onSearchCategory(
      SearchCategory event, Emitter<CategoryScreenState> emit) async {
    emit(SearchingCategory(
        categories: state.categories,
        firstDocument: state.firstDocument,
        lastDocument: state.lastDocument,
        query: state.query,
        categoriesCount: state.categoriesCount,
        currentPageIndex: state.currentPageIndex));
    CategoryPageInfo pageInfo =
        await CategoryRepository().getCategoryPageInfo(event.query);
    emit(CategoryScreenLoaded(
        categories: pageInfo.categories,
        firstDocument: pageInfo.firstDocument,
        lastDocument: pageInfo.lastDocument,
        query: '',
        currentPageIndex: 0,
        categoriesCount: pageInfo.categoriesCount));
  }

  FutureOr<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryScreenState> emit) async {
    await CategoryRepository()
        .deleteCategory(event.id)
        .whenComplete(() => _onLoadCategories(event, emit));
  }
}
