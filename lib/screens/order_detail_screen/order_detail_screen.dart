import 'package:admin_ecommerce_app/blocs/order_tracking_bloc/order_tracking_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/my_outlined_button.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/order_status_extensions.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/order_status.dart';
import 'package:admin_ecommerce_app/models/tracking_status.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/customer_information.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/order_items_table.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/tracking_information_widget.dart';
import 'package:admin_ecommerce_app/utils/pdf_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order});

  final OrderModel order;

  static const routeName = "/order-detail";

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderStatus? newOrderStatus;

  @override
  void initState() {
    super.initState();
    context
        .read<OrderTrackingBloc>()
        .add(LoadOrderTracking(orderId: widget.order.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context)
                  ? 20
                  : AppDimensions.defaultHorizontalContentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenNameSection("Order Detail",
                  hasDefaultBackButton: true),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const MyIcon(icon: AppAssets.icCalendar),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.order.createdAt
                                  .toDate()
                                  .toFullDateTimeFormat(),
                              style: AppStyles.labelMedium),
                          Text(widget.order.orderNumber,
                              style: AppStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Wrap(
                    children: [
                      MyOutlinedButton(
                          height: 40,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {},
                          child: DropdownButton<OrderStatus>(
                            itemHeight: 48,
                            icon: const MyIcon(
                              icon: AppAssets.icArrowDown,
                              colorFilter: ColorFilter.mode(
                                  AppColors.greyTextColor, BlendMode.srcIn),
                            ),
                            isDense: true,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            hint: const Text(
                              "Change Status",
                              style: AppStyles.bodyMedium,
                            ),
                            underline: const SizedBox(),
                            style: AppStyles.bodyMedium
                                .copyWith(color: AppColors.primaryColor),
                            value: newOrderStatus,
                            items: OrderStatus.values.map((OrderStatus value) {
                              return DropdownMenuItem<OrderStatus>(
                                value: value,
                                child: Text(value.statusName,
                                    style: AppStyles.bodyMedium.copyWith(
                                        color: AppColors.primaryColor)),
                              );
                            }).toList(),
                            onChanged: _onChangeStatus,
                          )),
                      SizedBox(width: Responsive.isDesktop(context) ? 20 : 10),
                      MyOutlinedButton(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onPressed: newOrderStatus == null ? null : _onSave,
                          child: Text("Save",
                              style: AppStyles.bodyMedium
                                  .copyWith(color: AppColors.greyTextColor))),
                      SizedBox(width: Responsive.isDesktop(context) ? 20 : 10),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            onPressed: _onPrint,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: AppDimensions
                                        .defaultButtonBorderRadius),
                                elevation: 0,
                                backgroundColor: AppColors.darkGreyColor,
                                padding: const EdgeInsets.all(8)),
                            child: const MyIcon(
                                icon: AppAssets.icPrinter,
                                height: 24,
                                width: 24)),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Divider(color: AppColors.primaryColor),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomerInformation(order: widget.order),
                        const SizedBox(height: 20),
                        OrderItemsTable(order: widget.order)
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) const SizedBox(width: 20),
                  if (!Responsive.isMobile(context))
                    Expanded(
                        child: TrackingInformation(orderId: widget.order.id)),
                ],
              ),
              const SizedBox(height: 20),
              if (Responsive.isMobile(context))
                TrackingInformation(orderId: widget.order.id),
              if (Responsive.isMobile(context)) const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangeStatus(OrderStatus? newStatus) {
    setState(() {
      newOrderStatus = newStatus;
    });
  }

  Future<void> _onSave() async {
    context.read<OrderTrackingBloc>().add(UpdateOrderStatus(
        order: widget.order,
        status: TrackingStatus(
          id: "",
          status: newOrderStatus ?? widget.order.currentOrderStatus,
          createAt: Timestamp.now(),
        )));

    // reset status in dropdown button
    _onChangeStatus(null);
  }

  void _onPrint() async {
    final orderItems = await OrderRepository().fetchOrderItems(widget.order.id);
    await PdfUtils()
        .generateInvoice(order: widget.order, orderItems: orderItems);
  }
}
