import 'package:admin_ecommerce_app/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_tracking_event.dart';
part 'order_tracking_state.dart';

class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  OrderTrackingBloc({required DashboardBloc dashboardBloc})
      : _dashboardBloc = dashboardBloc,
        super(OrderTrackingInitial()) {
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<LoadOrderTracking>(_onLoadOrderTracking);
  }

  final DashboardBloc _dashboardBloc;

  _onLoadOrderTracking(
      LoadOrderTracking event, Emitter<OrderTrackingState> emit) async {
    try {
      emit(OrderTrackingLoading());
      final List<TrackingStatus> trackingStatuses =
          await OrderRepository().fetchOrderTracking(event.orderId);
      emit(OrderTrackingLoaded(trackingStatuses: trackingStatuses));
    } catch (e) {
      emit(OrderTrackingError(message: e.toString()));
    }
  }

  _onUpdateOrderStatus(
      UpdateOrderStatus event, Emitter<OrderTrackingState> emit) async {
    try {
      await OrderRepository().updateOrderStatus(event.orderId, event.status);

      _dashboardBloc.add(
          UpdateOrders(orderId: event.orderId, trackingStatus: event.status));

      if (state is OrderTrackingLoaded) {
        final currentTrackingStatuses =
            (state as OrderTrackingLoaded).trackingStatuses;
        currentTrackingStatuses.insert(0, event.status);
        emit((state as OrderTrackingLoaded).copyWith(
            trackingStatuses: currentTrackingStatuses,
            lastUpdateTime: DateTime.now()));
      }
    } catch (e) {
      emit(OrderTrackingError(message: e.toString()));
    }
  }
}
