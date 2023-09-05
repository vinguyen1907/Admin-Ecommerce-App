part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class SetOrders extends OrdersEvent {
  const SetOrders({
    required this.orders,
    required this.totalOrdersCount,
    this.lastDocument,
  });

  final List<OrderModel> orders;
  final int totalOrdersCount;
  final DocumentSnapshot? lastDocument;

  @override
  List<Object?> get props => [orders, totalOrdersCount, lastDocument];
}

class LoadMoreOrders extends OrdersEvent {
  const LoadMoreOrders();
}

class SearchOrders extends OrdersEvent {
  const SearchOrders({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class NextPage extends OrdersEvent {
  const NextPage();
}

class PreviousPage extends OrdersEvent {
  const PreviousPage();
}

class ClearSearch extends OrdersEvent {
  const ClearSearch();
}
