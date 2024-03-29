part of 'order_tracking_bloc.dart';

sealed class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderTracking extends OrderTrackingEvent {
  const LoadOrderTracking({
    required this.orderId,
  });

  final String orderId;

  @override
  List<Object> get props => [orderId];
}

class UpdateOrderStatus extends OrderTrackingEvent {
  const UpdateOrderStatus({
    required this.order,
    required this.status,
  });

  final OrderModel order;
  final TrackingStatus status;

  @override
  List<Object> get props => [order, status];
}
