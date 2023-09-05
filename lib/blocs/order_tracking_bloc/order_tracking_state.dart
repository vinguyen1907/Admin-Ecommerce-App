// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_tracking_bloc.dart';

sealed class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object?> get props => [];
}

final class OrderTrackingInitial extends OrderTrackingState {}

final class OrderTrackingLoading extends OrderTrackingState {}

class OrderTrackingLoaded extends OrderTrackingState {
  final List<TrackingStatus> trackingStatuses;
  final DateTime? lastUpdateTime;

  const OrderTrackingLoaded({
    required this.trackingStatuses,
    this.lastUpdateTime,
  });

  @override
  List<Object?> get props => [trackingStatuses, lastUpdateTime];

  OrderTrackingLoaded copyWith({
    List<TrackingStatus>? trackingStatuses,
    DateTime? lastUpdateTime,
  }) {
    return OrderTrackingLoaded(
      trackingStatuses: trackingStatuses ?? this.trackingStatuses,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }
}

final class OrderTrackingError extends OrderTrackingState {
  final String message;

  const OrderTrackingError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
