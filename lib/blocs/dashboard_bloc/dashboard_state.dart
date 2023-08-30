part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final List<OrderModel> orders;
  final int productCount;

  const DashboardLoaded({required this.orders, required this.productCount});

  @override
  List<Object> get props => [orders, productCount];

  double get totalSales {
    double total = 0;
    for (var order in orders) {
      total += order.orderSummary.total;
    }
    return total;
  }

  int get totalOrders => orders.length;
}

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
