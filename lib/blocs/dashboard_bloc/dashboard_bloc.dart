import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/orders_monthly_statistics.dart';
import 'package:admin_ecommerce_app/models/orders_with_last_doc.dart';
import 'package:admin_ecommerce_app/models/product.dart';
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
      final ordersStatisticsTask = StatisticsRepository().getOrdersStatistics();
      final ordersTask = OrderRepository().fetchLatestOrders();
      final productCountTask = ProductRepository().getProductsCount();
      final monthlySalesTask = StatisticsRepository().getMonthlySales();
      final topProductsTask = ProductRepository().fetchTopProducts();
      final productsStatisticsTask =
          StatisticsRepository().getProductsStatistics();

      await Future.wait([
        ordersStatisticsTask,
        ordersTask,
        productCountTask,
        monthlySalesTask,
        topProductsTask,
        productsStatisticsTask,
      ]);

      // Access the results of each statement
      final Map<String, dynamic> statistics = await ordersStatisticsTask;
      final OrdersWithLastDoc orders = await ordersTask;
      final int productCount = await productCountTask;
      final List<OrdersMonthlyStatistics> monthlySales = await monthlySalesTask;
      final List<Product> topProducts = await topProductsTask;
      final Map<String, double> productsStatistics =
          await productsStatisticsTask;

      emit(DashboardLoaded(
        latestOrders: orders.orders,
        productCount: productCount,
        lastDocument: orders.lastDocument,
        totalOrdersCount: statistics['total_orders']!.toInt(),
        totalSales: statistics['total_sales']!,
        monthlyStatistics: monthlySales,
        topProducts: topProducts,
        totalSoldCount: productsStatistics['soldQuantity']!.toInt(),
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
