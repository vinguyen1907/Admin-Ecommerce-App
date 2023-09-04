import 'package:admin_ecommerce_app/blocs/order_tracking_bloc/order_tracking_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/tracking_status_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackingInformation extends StatelessWidget {
  const TrackingInformation({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return PrimaryBackground(
      child: BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
        builder: (context, state) {
          if (state is OrderTrackingLoading) {
            return const Center(
              child: CustomLoadingWidget(),
            );
          }
          if (state is OrderTrackingError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is OrderTrackingLoaded) {
            final List<TrackingStatus> statuses = state.trackingStatuses;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statuses.length,
              itemBuilder: (_, index) {
                final status = statuses[index];
                return TrackingStatusItemWidget(
                    status: status, isLastStatus: index < statuses.length - 1);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
