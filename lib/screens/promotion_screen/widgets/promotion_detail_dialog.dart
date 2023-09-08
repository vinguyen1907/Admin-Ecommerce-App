import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/widgets/promotion_detail_line.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/widgets/promotion_item.dart';
import 'package:flutter/material.dart';

class PromotionDetailDialog extends StatelessWidget {
  const PromotionDetailDialog({super.key, required this.promotion});

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final List<String> labels = [
      "Content",
      "Start Time",
      "End Time",
      "Maximum Discount",
      "Minimum Order Value",
      "Order Value",
      "Amount",
      "Usage",
    ];
    final List<String> contents = [
      promotion.code,
      promotion.content,
      promotion.startTime.toDateTimeFormat(),
      promotion.endTime.toDateTimeFormat(),
      promotion.maximumDiscountValue?.toString() ?? "No",
      promotion.minimumOrderValue?.toString() ?? "No",
      promotion.amountString,
      "${promotion.usedQuantity}/${promotion.quantity}",
    ];

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: AppDimensions.defaultBorderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromotionItem(
                promotion: promotion,
                height: 160,
                width: 260,
                onGetPromotion: () {}),
            const SizedBox(width: 30),
            SizedBox(
                width: size.width * 0.2,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: labels.length,
                  itemBuilder: (_, index) {
                    return PromotionDetailLine(
                      label: labels[index],
                      content: contents[index],
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: 5);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
