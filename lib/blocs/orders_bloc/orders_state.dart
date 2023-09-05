part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState({
    required this.orders,
    required this.displayOrders,
    this.searchOrders,
    required this.totalOrdersCount,
    required this.currentPageIndex,
    required this.lastDocument,
  });

  final List<OrderModel> orders;
  final List<OrderModel> displayOrders;
  final List<OrderModel>? searchOrders;
  final int totalOrdersCount;
  final DocumentSnapshot? lastDocument;
  final int currentPageIndex;

  int get totalPagesCount =>
      (totalOrdersCount / AppConstants.numberItemsPerPage).ceil();

  @override
  List<Object?> get props => [
        orders,
        displayOrders,
        searchOrders,
        totalOrdersCount,
        lastDocument,
        currentPageIndex,
      ];
}

final class OrdersInitial extends OrdersState {
  const OrdersInitial()
      : super(
            orders: const [],
            displayOrders: const [],
            searchOrders: null,
            totalOrdersCount: 0,
            currentPageIndex: 0,
            lastDocument: null);
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading({
    required super.orders,
    required super.displayOrders,
    required super.searchOrders,
    required super.totalOrdersCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class OrdersLoaded extends OrdersState {
  const OrdersLoaded({
    required super.orders,
    required super.displayOrders,
    required super.searchOrders,
    required super.totalOrdersCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class OrdersError extends OrdersState {
  const OrdersError({
    required this.message,
    required super.orders,
    required super.displayOrders,
    required super.searchOrders,
    required super.totalOrdersCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
        orders,
        displayOrders,
        searchOrders,
        totalOrdersCount,
        lastDocument,
        currentPageIndex,
      ];
}

final class LoadingMoreOrders extends OrdersState {
  const LoadingMoreOrders({
    required super.orders,
    required super.displayOrders,
    required super.searchOrders,
    required super.totalOrdersCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class SearchingOrders extends OrdersState {
  const SearchingOrders({
    required super.orders,
    required super.displayOrders,
    required super.searchOrders,
    required super.totalOrdersCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}
