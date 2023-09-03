import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/customer_information_headline.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/headline_richtext.dart';
import 'package:flutter/material.dart';

class CustomerInformation extends StatelessWidget {
  const CustomerInformation({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryBackground(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerInformationHeadline(
                  icon: AppAssets.icUser,
                  title: "Customer",
                  children: [
                    Text(order.customerName,
                        style: AppStyles.bodyMedium
                            .copyWith(color: AppColors.primaryColor)),
                    Text(order.customerPhoneNumber,
                        style: AppStyles.bodyMedium
                            .copyWith(color: AppColors.primaryColor)),
                  ]),
              const SizedBox(width: 50),
              CustomerInformationHeadline(
                icon: AppAssets.icLocation,
                title: "Delivery to",
                children: [
                  HeadlineRichText(
                      label: "Country: ", content: order.address.country),
                  HeadlineRichText(
                      label: "State: ", content: order.address.state),
                  HeadlineRichText(
                      label: "City: ", content: order.address.city),
                  HeadlineRichText(
                      label: "Street: ", content: order.address.street),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
