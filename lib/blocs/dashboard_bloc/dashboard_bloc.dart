import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
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
      final salesStatistics = await OrderRepository().getSalesStatistics();
      final orders = await OrderRepository().fetchLatestOrders();
      final productCount = await ProductRepository().getProductsCount();
      emit(DashboardLoaded(
        latestOrders: orders.orders,
        productCount: productCount,
        lastDocument: orders.lastDocument,
        totalOrdersCount: salesStatistics['total_orders']!.toInt(),
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
