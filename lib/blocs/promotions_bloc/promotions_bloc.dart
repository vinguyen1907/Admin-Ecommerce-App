import 'dart:typed_data';

import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/models/promotion_type.dart';
import 'package:admin_ecommerce_app/repositories/promotion_repository.dart';
import 'package:admin_ecommerce_app/services/firebase_storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'promotions_event.dart';
part 'promotions_state.dart';

class PromotionsBloc extends Bloc<PromotionsEvent, PromotionsState> {
  PromotionsBloc() : super(const PromotionsInitial()) {
    on<LoadPromotions>(_onLoadPromotions);
    // on<SetPromotions>(_onSetPromotions);
    on<LoadMorePromotions>(_onLoadMorePromotions);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<SearchPromotions>(_onSearchPromotions);
    on<ClearSearch>(_onClearSearch);
    on<DeletePromotion>(_onDeletePromotion);
    on<AddPromotion>(_onAddPromotion);
    on<UpdatePromotion>(_onUpdatePromotion);
  }

  _onLoadPromotions(LoadPromotions event, Emitter<PromotionsState> emit) async {
    emit(PromotionsLoading(
      promotions: state.promotions,
      displayPromotions: state.displayPromotions,
      searchPromotions: state.searchPromotions,
      totalPromotionsCount: state.totalPromotionsCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
    try {
      final promotions = await PromotionRepository().fetchLatestPromotions();
      final int totalPromotionsCount =
          await PromotionRepository().fetchTotalPromotionCount();
      emit(PromotionsLoaded(
        promotions: promotions.promotions,
        displayPromotions: promotions.promotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: totalPromotionsCount,
        lastDocument: promotions.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  // _onSetPromotions(SetPromotions event, Emitter<PromotionsState> emit) {
  //   emit(PromotionsLoaded(
  //     promotions: event.promotions,
  //     displayPromotions: event.Promotions,
  //     searchPromotions: state.searchPromotions,
  //     totalPromotionsCount: event.totalPromotionsCount,
  //     lastDocument: event.lastDocument,
  //     currentPageIndex: state.currentPageIndex,
  //   ));
  // }

  _onLoadMorePromotions(
      LoadMorePromotions event, Emitter<PromotionsState> emit) async {
    emit(PromotionsLoading(
      promotions: state.promotions,
      displayPromotions: state.displayPromotions,
      searchPromotions: state.searchPromotions,
      totalPromotionsCount: state.totalPromotionsCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
    try {
      final newPromotions = await PromotionRepository().fetchMorePromotions(
          lastDocument: state.lastDocument!,
          limit: AppConstants.numberItemsPerPage);
      final currentList = state.promotions;
      currentList.addAll(newPromotions.promotions);
      emit(PromotionsLoaded(
        promotions: currentList,
        displayPromotions: state.displayPromotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: state.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onNextPage(NextPage event, Emitter<PromotionsState> emit) async {
    print("Next page in bloc");
    try {
      final List<Promotion> currentList = state.promotions;
      final int newPageIndex = state.currentPageIndex + 1;
      final int startOfNewPage =
          newPageIndex * AppConstants.numberItemsPerPage + 1;
      int endOfNewPage = (newPageIndex + 1) * AppConstants.numberItemsPerPage;
      final bool alreadyLastPage = newPageIndex + 1 > state.totalPagesCount;

      if (!alreadyLastPage) {
        final bool hasPageData = currentList.length >= endOfNewPage;
        if (hasPageData) {
          emit(PromotionsLoaded(
            promotions: currentList,
            displayPromotions:
                currentList.sublist(startOfNewPage - 1, endOfNewPage - 1),
            searchPromotions: state.searchPromotions,
            totalPromotionsCount: state.totalPromotionsCount,
            lastDocument: state.lastDocument,
            currentPageIndex: newPageIndex,
          ));
        } else {
          final currentList = state.promotions;
          endOfNewPage = currentList.length;

          _emitLoadingMore(emit);
          final newPromotions = await PromotionRepository().fetchMorePromotions(
              lastDocument: state.lastDocument!,
              limit: AppConstants.numberItemsPerPage);
          currentList.addAll(newPromotions.promotions);
          emit(PromotionsLoaded(
            promotions: currentList,
            displayPromotions: currentList.sublist(startOfNewPage - 1),
            searchPromotions: state.searchPromotions,
            totalPromotionsCount: state.totalPromotionsCount,
            lastDocument: newPromotions.lastDocument,
            currentPageIndex: newPageIndex,
          ));
        }
      }
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onPreviousPage(PreviousPage event, Emitter<PromotionsState> emit) async {
    try {
      final List<Promotion> currentList = state.promotions;
      final alreadyFirstPage = state.currentPageIndex == 0;
      if (alreadyFirstPage) return;

      final int newPageIndex = state.currentPageIndex - 1;
      final int startOfNewPage =
          newPageIndex * AppConstants.numberItemsPerPage + 1;
      final int endOfNewPage =
          (newPageIndex + 1) * AppConstants.numberItemsPerPage;
      emit(PromotionsLoaded(
          promotions: state.promotions,
          displayPromotions:
              currentList.sublist(startOfNewPage - 1, endOfNewPage - 1),
          searchPromotions: state.searchPromotions,
          totalPromotionsCount: state.totalPromotionsCount,
          lastDocument: state.lastDocument,
          currentPageIndex: newPageIndex));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onSearchPromotions(
      SearchPromotions event, Emitter<PromotionsState> emit) async {
    try {
      emit(SearchingPromotions(
          promotions: state.promotions,
          displayPromotions: state.displayPromotions,
          searchPromotions: state.searchPromotions,
          totalPromotionsCount: state.totalPromotionsCount,
          lastDocument: state.lastDocument,
          currentPageIndex: state.currentPageIndex));
      final results = await PromotionRepository().searchOrder(event.query);
      emit(PromotionsLoaded(
        promotions: state.promotions,
        displayPromotions: state.displayPromotions,
        searchPromotions: results,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: state.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  _onClearSearch(ClearSearch event, Emitter<PromotionsState> emit) {
    emit(PromotionsLoaded(
      promotions: state.promotions,
      displayPromotions: state.displayPromotions,
      searchPromotions: null,
      totalPromotionsCount: state.totalPromotionsCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }

  _onDeletePromotion(
      DeletePromotion event, Emitter<PromotionsState> emit) async {
    try {
      await PromotionRepository().deletePromotion(event.promotion.id);
      final promotions = await PromotionRepository().fetchLatestPromotions();
      emit(PromotionsLoaded(
        promotions: promotions.promotions,
        displayPromotions: promotions.promotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: promotions.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onAddPromotion(AddPromotion event, Emitter<PromotionsState> emit) async {
    emit(UpdatingPromotion(
        promotions: state.promotions,
        displayPromotions: state.displayPromotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: state.lastDocument,
        currentPageIndex: state.currentPageIndex));
    try {
      final imgUrl = await FirebaseStorageService.uploadImageInUint8ListType(
          event.code, event.imageBytes);
      final Promotion promotion = Promotion.create(
        id: "",
        code: event.code,
        content: event.content,
        imgUrl: imgUrl,
        type: event.type,
        startTime: event.startTime,
        endTime: event.endTime,
        maximumDiscountValue: event.maximumDiscountValue,
        minimumOrderValue: event.minimumOrderValue,
        quantity: event.quantity,
        usedQuantity: 0,
        discountAmount: event.discountAmount,
        isDeleted: false,
      );
      await PromotionRepository().addPromotion(promotion: promotion);
      final promotions = await PromotionRepository().fetchLatestPromotions();
      emit(PromotionsLoaded(
        promotions: promotions.promotions,
        displayPromotions: promotions.promotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: promotions.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onUpdatePromotion(
      UpdatePromotion event, Emitter<PromotionsState> emit) async {
    emit(UpdatingPromotion(
        promotions: state.promotions,
        displayPromotions: state.displayPromotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: state.lastDocument,
        currentPageIndex: state.currentPageIndex));
    try {
      late final String imgUrl;
      if (event.imageBytes != null) {
        imgUrl = await FirebaseStorageService.uploadImageInUint8ListType(
            "promotion_img/${event.code}", event.imageBytes!);
      } else {
        imgUrl = event.currentImgUrl;
      }
      final Promotion promotion = Promotion.create(
        id: event.id,
        code: event.code,
        content: event.content,
        imgUrl: imgUrl,
        type: event.type,
        startTime: event.startTime,
        endTime: event.endTime,
        maximumDiscountValue: event.maximumDiscountValue,
        minimumOrderValue: event.minimumOrderValue,
        quantity: event.quantity,
        usedQuantity: 0,
        discountAmount: event.discountAmount,
        isDeleted: false,
      );
      print(promotion.toMap());
      await PromotionRepository().updatePromotion(promotion: promotion);
      final promotions = await PromotionRepository().fetchLatestPromotions();
      emit(PromotionsLoaded(
        promotions: promotions.promotions,
        displayPromotions: promotions.promotions,
        searchPromotions: state.searchPromotions,
        totalPromotionsCount: state.totalPromotionsCount,
        lastDocument: promotions.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _emitLoadingMore(Emitter<PromotionsState> emit) {
    emit(LoadingMorePromotions(
      promotions: state.promotions,
      displayPromotions: state.displayPromotions,
      searchPromotions: state.searchPromotions,
      totalPromotionsCount: state.totalPromotionsCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }

  _emitError(Emitter<PromotionsState> emit, String message) {
    emit(PromotionsError(
      message: message,
      promotions: state.promotions,
      displayPromotions: state.displayPromotions,
      searchPromotions: state.searchPromotions,
      totalPromotionsCount: state.totalPromotionsCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }
}
