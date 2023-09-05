import 'package:admin_ecommerce_app/common_widgets/color_dot.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/extensions/string_extensions.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/order_product_detail.dart';
import 'package:admin_ecommerce_app/repositories/order_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/order_summary_line.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/widgets/payment_status_badge.dart';
import 'package:flutter/material.dart';

class OrderItemsTable extends StatefulWidget {
  const OrderItemsTable({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderItemsTable> createState() => _OrderItemsTableState();
}

class _OrderItemsTableState extends State<OrderItemsTable> {
  late Future<List<OrderProductDetail>> fetchOrderItems;

  @override
  void initState() {
    super.initState();
    fetchOrderItems = OrderRepository().fetchOrderItems(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<OrderProductDetail>>(
            future: fetchOrderItems,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoadingWidget());
              }
              final orderItems = snapshot.data!;
              return SizedBox(
                width: double.infinity,
                child: DataTable(
                  horizontalMargin: Responsive.isDesktop(context) ? 10 : 0,
                  headingTextStyle: AppStyles.tableColumnName.copyWith(
                      fontSize: !Responsive.isDesktop(context) ? 12 : null),
                  dataTextStyle: AppStyles.tableCell.copyWith(
                      fontSize: !Responsive.isDesktop(context) ? 12 : null),
                  dataRowMaxHeight: 60,
                  columnSpacing: 10,
                  columns: const [
                    DataColumn(label: Text("#")),
                    DataColumn(label: Text("Product")),
                    DataColumn(label: Text("Price"), numeric: true),
                    DataColumn(label: Text("Qty"), numeric: true),
                    DataColumn(label: Text("Total"), numeric: true),
                  ],
                  rows: [
                    ...List.generate(
                      orderItems.length,
                      (index) {
                        final item = orderItems[index];
                        return DataRow(
                          cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 5, bottom: 5),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              AppDimensions.defaultBorderRadius,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  item.productImgUrl),
                                              fit: BoxFit.cover))),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.bodyLarge.copyWith(
                                                color: AppColors.primaryColor)),
                                        FittedBox(
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              const Text("Color: ",
                                                  style: AppStyles.bodySmall),
                                              ColorDotWidget(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  color: item.color.toColor()),
                                              Text("Size: ${item.size}",
                                                  style: AppStyles.bodySmall),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(item.productPrice.toPriceString())),
                            DataCell(Text(item.quantity.toString())),
                            DataCell(Text(item.totalPrice.toPriceString())),
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          OrderSummaryLine(
              label: "Amount: ", number: widget.order.orderSummary.amount),
          OrderSummaryLine(
              label: "Shipping: ", number: widget.order.orderSummary.shipping),
          OrderSummaryLine(
              label: "Promotion: ",
              number: widget.order.orderSummary.promotionDiscount),
          OrderSummaryLine(
            label: "Total: ",
            number: widget.order.orderSummary.total,
            numberFontSize: 20,
          ),
          const SizedBox(height: 10),
          PaymentStatusBadge(paymentMethod: widget.order.paymentMethod),
        ],
      ),
    );
  }
}
