import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(const OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<SetOrders>(_onSetOrders);
    on<LoadMoreOrders>(_onLoadMoreOrders);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<SearchOrders>(_onSearchOrders);
    on<ClearSearch>(_onClearSearch);
  }

  _onLoadOrders(LoadOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading(
      orders: state.orders,
      displayOrders: state.displayOrders,
      searchOrders: state.searchOrders,
      totalOrdersCount: state.totalOrdersCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
    try {
      final orders = await OrderRepository().fetchLatestOrders();
      emit(OrdersLoaded(
        orders: orders.orders,
        displayOrders: state.displayOrders,
        searchOrders: state.searchOrders,
        totalOrdersCount: state.totalOrdersCount,
        lastDocument: orders.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onSetOrders(SetOrders event, Emitter<OrdersState> emit) {
    emit(OrdersLoaded(
      orders: event.orders,
      displayOrders: event.orders,
      searchOrders: state.searchOrders,
      totalOrdersCount: event.totalOrdersCount,
      lastDocument: event.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }

  _onLoadMoreOrders(LoadMoreOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading(
      orders: state.orders,
      displayOrders: state.displayOrders,
      searchOrders: state.searchOrders,
      totalOrdersCount: state.totalOrdersCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
    try {
      final newOrders = await OrderRepository().fetchMoreOrders(
          lastDocument: state.lastDocument!,
          limit: AppConstants.numberItemsPerPage);
      final currentList = state.orders;
      currentList.addAll(newOrders.orders);
      emit(OrdersLoaded(
        orders: currentList,
        displayOrders: state.displayOrders,
        searchOrders: state.searchOrders,
        totalOrdersCount: state.totalOrdersCount,
        lastDocument: state.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onNextPage(NextPage event, Emitter<OrdersState> emit) async {
    try {
      final List<OrderModel> currentList = state.orders;
      final int newPageIndex = state.currentPageIndex + 1;
      final int startOfNewPage =
          newPageIndex * AppConstants.numberItemsPerPage + 1;
      int endOfNewPage = (newPageIndex + 1) * AppConstants.numberItemsPerPage;
      final bool alreadyLastPage = newPageIndex + 1 > state.totalPagesCount;

      if (!alreadyLastPage) {
        final bool hasPageData = currentList.length >= endOfNewPage;
        if (hasPageData) {
          emit(OrdersLoaded(
            orders: currentList,
            displayOrders:
                currentList.sublist(startOfNewPage - 1, endOfNewPage - 1),
            searchOrders: state.searchOrders,
            totalOrdersCount: state.totalOrdersCount,
            lastDocument: state.lastDocument,
            currentPageIndex: newPageIndex,
          ));
        } else {
          final currentList = state.orders;
          endOfNewPage = currentList.length;

          _emitLoadingMore(emit);
          final newOrders = await OrderRepository().fetchMoreOrders(
              lastDocument: state.lastDocument!,
              limit: AppConstants.numberItemsPerPage);
          currentList.addAll(newOrders.orders);
          emit(OrdersLoaded(
            orders: currentList,
            displayOrders: currentList.sublist(startOfNewPage - 1),
            searchOrders: state.searchOrders,
            totalOrdersCount: state.totalOrdersCount,
            lastDocument: newOrders.lastDocument,
            currentPageIndex: newPageIndex,
          ));
        }
      }
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onPreviousPage(PreviousPage event, Emitter<OrdersState> emit) async {
    try {
      final List<OrderModel> currentList = state.orders;
      final alreadyFirstPage = state.currentPageIndex == 0;
      if (alreadyFirstPage) return;

      final int newPageIndex = state.currentPageIndex - 1;
      final int startOfNewPage =
          newPageIndex * AppConstants.numberItemsPerPage + 1;
      final int endOfNewPage =
          (newPageIndex + 1) * AppConstants.numberItemsPerPage;
      emit(OrdersLoaded(
          orders: state.orders,
          displayOrders:
              currentList.sublist(startOfNewPage - 1, endOfNewPage - 1),
          searchOrders: state.searchOrders,
          totalOrdersCount: state.totalOrdersCount,
          lastDocument: state.lastDocument,
          currentPageIndex: newPageIndex));
    } catch (e) {
      _emitError(emit, e.toString());
    }
  }

  _onSearchOrders(SearchOrders event, Emitter<OrdersState> emit) async {
    try {
      emit(SearchingOrders(
          orders: state.orders,
          displayOrders: state.displayOrders,
          searchOrders: state.searchOrders,
          totalOrdersCount: state.totalOrdersCount,
          lastDocument: state.lastDocument,
          currentPageIndex: state.currentPageIndex));
      final results = await OrderRepository().searchOrder(event.query);
      emit(OrdersLoaded(
        orders: state.orders,
        displayOrders: state.displayOrders,
        searchOrders: results,
        totalOrdersCount: state.totalOrdersCount,
        lastDocument: state.lastDocument,
        currentPageIndex: state.currentPageIndex,
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  _onClearSearch(ClearSearch event, Emitter<OrdersState> emit) {
    emit(OrdersLoaded(
      orders: state.orders,
      displayOrders: state.displayOrders,
      searchOrders: null,
      totalOrdersCount: state.totalOrdersCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }

  _emitLoadingMore(Emitter<OrdersState> emit) {
    emit(LoadingMoreOrders(
      orders: state.orders,
      displayOrders: state.displayOrders,
      searchOrders: state.searchOrders,
      totalOrdersCount: state.totalOrdersCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }

  _emitError(Emitter<OrdersState> emit, String message) {
    emit(OrdersError(
      message: message,
      orders: state.orders,
      displayOrders: state.displayOrders,
      searchOrders: state.searchOrders,
      totalOrdersCount: state.totalOrdersCount,
      lastDocument: state.lastDocument,
      currentPageIndex: state.currentPageIndex,
    ));
  }
}
