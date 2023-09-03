// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<OrderModel> orders;
  final int productCount;
  final DateTime? lastUpdateTime;

  const DashboardLoaded(
      {required this.orders, required this.productCount, this.lastUpdateTime});

  @override
  List<Object?> get props => [orders, productCount, lastUpdateTime];

  double get totalSales {
    double total = 0;
    for (var order in orders) {
      total += order.orderSummary.total;
    }
    return total;
  }

  int get totalOrders => orders.length;

  DashboardLoaded copyWith({
    List<OrderModel>? orders,
    int? productCount,
    DateTime? lastUpdateTime,
  }) {
    return DashboardLoaded(
      orders: orders ?? this.orders,
      productCount: productCount ?? this.productCount,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }
}

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
