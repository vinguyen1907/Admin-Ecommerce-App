import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/orders_monthly_statistics.dart';
import 'package:admin_ecommerce_app/models/orders_with_last_doc.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:admin_ecommerce_app/repositories/statistics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<UpdateOrders>(_onUpdateOrders);
  }

  _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    try {
      emit(DashboardLoading());
      final ordersStatistics =
          await StatisticsRepository().getOrdersStatistics();
      final OrdersWithLastDoc orders =
          await OrderRepository().fetchLatestOrders();
      final int productCount = await ProductRepository().getProductsCount();
      final List<OrdersMonthlyStatistics> monthlySales =
          await StatisticsRepository().getMonthlySales();
      emit(DashboardLoaded(
        latestOrders: orders.orders,
        productCount: productCount,
        lastDocument: orders.lastDocument,
        totalOrdersCount: ordersStatistics['total_orders']!.toInt(),
        totalSales: ordersStatistics['total_sales']!,
        monthlyStatistics: monthlySales,
      ));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  _onUpdateOrders(UpdateOrders event, Emitter<DashboardState> emit) async {
    try {
      if (state is DashboardLoaded) {
        final currentList = (state as DashboardLoaded).latestOrders;
        final index =
            currentList.indexWhere((element) => element.id == event.orderId);
        currentList[index] = currentList[index]
            .copyWith(currentOrderStatus: event.trackingStatus.status);

        emit((state as DashboardLoaded).copyWith(
            latestOrders: currentList, lastUpdateTime: DateTime.now()));
      }
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
