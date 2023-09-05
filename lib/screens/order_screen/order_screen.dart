import 'package:admin_ecommerce_app/blocs/orders_bloc/orders_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/paginator.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/common_widgets/search_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/table_divider.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/screens/order_screen/widgets/orders_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static const String routeName = "/order-screen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenHorizontalPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenNameSection("Orders"),
              BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OrdersError) {
                  return Center(child: Text(state.message.toString()));
                  // return const Center(child: Text("Error"));
                }
                final orders = state.searchOrders ?? state.displayOrders;
                return PrimaryBackground(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: SearchWidget(
                            controller: controller,
                            onQuery: _onSearch,
                            onClear: _onClear,
                          )),
                      const TableDivider(),
                      if (orders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No orders found"),
                        ),
                      if (orders.isNotEmpty)
                        OrdersTable(
                            orders: orders,
                            isLoading: state is LoadingMoreOrders ||
                                state is SearchingOrders),

                      // Paginator
                      if (state.searchOrders == null)
                        Paginator(
                            currentPageIndex: state.currentPageIndex,
                            onPreviousPage: _onPreviousPage,
                            onNextPage: _onNextPage)
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearch() {
    if (controller.text.isNotEmpty) {
      context.read<OrdersBloc>().add(SearchOrders(query: controller.text));
    }
  }

  void _onClear() {
    controller.clear();
    context.read<OrdersBloc>().add(const ClearSearch());
  }

  void _onNextPage() {
    context.read<OrdersBloc>().add(const NextPage());
  }

  void _onPreviousPage() {
    context.read<OrdersBloc>().add(const PreviousPage());
  }
}
