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
  final List<OrderModel> latestOrders;
  final DocumentSnapshot? lastDocument;
  final int productCount;
  final int totalOrdersCount;
  final double totalSales;
  final List<OrdersMonthlyStatistics> monthlyStatistics;
  final DateTime? lastUpdateTime;

  const DashboardLoaded(
      {required this.latestOrders,
      required this.lastDocument,
      required this.productCount,
      required this.totalOrdersCount,
      required this.totalSales,
      required this.monthlyStatistics,
      this.lastUpdateTime});

  @override
  List<Object?> get props => [
        latestOrders,
        lastDocument,
        productCount,
        totalOrdersCount,
        totalSales,
        monthlyStatistics,
        lastUpdateTime,
      ];

  int get totalOrders => latestOrders.length;

  DashboardLoaded copyWith({
    List<OrderModel>? latestOrders,
    DocumentSnapshot? lastDocument,
    int? productCount,
    int? totalOrdersCount,
    double? totalSales,
    List<OrdersMonthlyStatistics>? monthlyStatistics,
    DateTime? lastUpdateTime,
  }) {
    return DashboardLoaded(
      latestOrders: latestOrders ?? this.latestOrders,
      lastDocument: lastDocument ?? this.lastDocument,
      productCount: productCount ?? this.productCount,
      totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
      totalSales: totalSales ?? this.totalSales,
      monthlyStatistics: monthlyStatistics ?? this.monthlyStatistics,
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
