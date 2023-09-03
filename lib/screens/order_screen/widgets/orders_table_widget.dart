import 'package:admin_ecommerce_app/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/widgets/order_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersTableWidget extends StatelessWidget {
  const OrdersTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryBackground(child: BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is DashboardError) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is DashboardLoaded) {
          final orders = state.orders;
          return DataTable(
            headingTextStyle: AppStyles.tableColumnName,
            dataTextStyle: AppStyles.tableCell,
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
            rows: List.generate(
              orders.length > 10 ? 10 : orders.length,
              (index) {
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
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    ));
  }
}
