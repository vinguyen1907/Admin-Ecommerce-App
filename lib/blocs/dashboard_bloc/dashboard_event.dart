part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class UpdateOrders extends DashboardEvent {
  final String orderId;
  final TrackingStatus trackingStatus;

  const UpdateOrders({required this.orderId, required this.trackingStatus});

  @override
  List<Object> get props => [orderId, trackingStatus];
}
