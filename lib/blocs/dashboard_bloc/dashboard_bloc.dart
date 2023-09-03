import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';
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
      final List<OrderModel> orders = await OrderRepository().fetchAllOrders();
      final productCount = await ProductRepository().getProductsCount();
      emit(DashboardLoaded(orders: orders, productCount: productCount));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  _onUpdateOrders(UpdateOrders event, Emitter<DashboardState> emit) async {
    try {
      if (state is DashboardLoaded) {
        final currentList = (state as DashboardLoaded).orders;
        final index =
            currentList.indexWhere((element) => element.id == event.orderId);
        currentList[index] = currentList[index]
            .copyWith(currentOrderStatus: event.trackingStatus.status);

        emit((state as DashboardLoaded)
            .copyWith(orders: currentList, lastUpdateTime: DateTime.now()));
      }
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
