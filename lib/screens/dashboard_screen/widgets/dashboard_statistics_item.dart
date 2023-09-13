import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class DashboardStatisticsItem extends StatelessWidget {
  final String iconAsset;
  final String title;
  final double value;
  final Color iconInnerColor;
  final Color iconOuterColor;

  const DashboardStatisticsItem({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.value,
    required this.iconInnerColor,
    required this.iconOuterColor,
  });

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    return Container(
      // width: (size.width * 5 / 6 - 40 - 44 * 2) / 3,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: AppDimensions.defaultBorderRadius,
        color: AppColors.whiteColor,
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: iconOuterColor,
          child: CircleAvatar(
              radius: 15,
              backgroundColor: iconInnerColor,
              child: MyIcon(
                icon: iconAsset,
                height: 16,
                colorFilter: const ColorFilter.mode(
                    AppColors.whiteColor, BlendMode.srcIn),
              )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppStyles.bodySmall,
              ),
              Text(
                "\$$value",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.labelLarge,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
