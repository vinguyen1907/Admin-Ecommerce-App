import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/order_status_badge.dart';
import 'package:admin_ecommerce_app/screens/order_detail_screen/order_detail_screen.dart';
import 'package:flutter/material.dart';

class OrdersTable extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isLoading;
  const OrdersTable({
    super.key,
    required this.orders,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CustomLoadingWidget()
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              headingTextStyle: AppStyles.tableColumnName.copyWith(
                  fontSize: !Responsive.isDesktop(context) ? 12 : null),
              dataTextStyle: AppStyles.tableCell.copyWith(
                  fontSize: !Responsive.isDesktop(context) ? 12 : null),
              columnSpacing: Responsive.isDesktop(context)
                  ? 80
                  : Responsive.isTablet(context)
                      ? 30
                      : 10,
              columns: const <DataColumn>[
                DataColumn(label: Text("#")),
                DataColumn(label: Text("Order ID")),
                DataColumn(
                    label:
                        Text("Customer Name", overflow: TextOverflow.ellipsis)),
                DataColumn(label: Text("Date")),
                DataColumn(numeric: true, label: Text("Price")),
                DataColumn(label: Text("Status")),
              ],
              rows: List.generate(orders.length, (index) {
                final order = orders[index];
                return DataRow(
                    cells: <DataCell>[
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(
                        order.id,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        order.customerName,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        order.createdAt.toDate().toDateTimeFormat(),
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        order.orderSummary.total.toPriceString(),
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(OrderStatusBadge(order: order)),
                    ],
                    onSelectChanged: (isSelected) {
                      if (isSelected!) {
                        _onRowSelected(context, order);
                      }
                    });
              }),
            ),
          );
  }

  void _onRowSelected(BuildContext context, OrderModel order) {
    Navigator.pushNamed(context, OrderDetailScreen.routeName, arguments: order);
  }
}
