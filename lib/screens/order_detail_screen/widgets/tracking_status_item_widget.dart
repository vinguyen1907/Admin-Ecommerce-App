import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/order_status.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:flutter/material.dart';

class TrackingStatusItemWidget extends StatelessWidget {
  const TrackingStatusItemWidget({
    super.key,
    required this.status,
    required this.isLastStatus,
  });

  final TrackingStatus status;
  final bool isLastStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${status.createAt.toDate().month}/${status.createAt.toDate().day}",
                style: AppStyles.labelMedium,
              ),
              Text(
                  "${status.createAt.toDate().hour}:${status.createAt.toDate().minute}",
                  style: AppStyles.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryColor),
            ),
            if (isLastStatus)
              Container(
                height: 50,
                width: 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.primaryColor),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${orderStatusName[status.status]}",
                style: AppStyles.labelMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (status.currentLocation != null)
                Text("${status.currentLocation}", style: AppStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
