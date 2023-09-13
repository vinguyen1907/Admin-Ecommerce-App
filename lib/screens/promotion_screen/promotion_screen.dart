import 'package:admin_ecommerce_app/blocs/promotions_bloc/promotions_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_app_bar.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/paginator.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/common_widgets/search_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/table_divider.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/edit_promotion_screen/edit_promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/widgets/promotions_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  static const String routeName = "/promotion-screen";

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _onLoadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? const MyAppBar() : null,
      body: SingleChildScrollView(
        child: ScreenHorizontalPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenNameSection("Promotions"),
              BlocBuilder<PromotionsBloc, PromotionsState>(
                  builder: (context, state) {
                if (state is PromotionsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PromotionsError) {
                  return Center(child: Text(state.message.toString()));
                  // return const Center(child: Text("Error"));
                }
                final promotions =
                    state.searchPromotions ?? state.displayPromotions;
                return PrimaryBackground(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SearchWidget(
                            controller: controller,
                            onQuery: _onSearch,
                            onClear: _onClear,
                          ),
                          MyElevatedButton(
                              onPressed: _onAddPromotion,
                              widget: const Text('Add New'))
                        ],
                      ),
                      const TableDivider(),
                      if (promotions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No Promotions found"),
                        ),
                      if (promotions.isNotEmpty)
                        PromotionsTable(
                            promotions: promotions,
                            isLoading: state is LoadingMorePromotions ||
                                state is SearchingPromotions),

                      // Paginator
                      if (state.searchPromotions == null)
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
      context
          .read<PromotionsBloc>()
          .add(SearchPromotions(query: controller.text));
    }
  }

  void _onClear() {
    controller.clear();
    context.read<PromotionsBloc>().add(const ClearSearch());
  }

  void _onNextPage() {
    context.read<PromotionsBloc>().add(const NextPage());
  }

  void _onPreviousPage() {
    context.read<PromotionsBloc>().add(const PreviousPage());
  }

  void _onLoadData() {
    final state = context.read<PromotionsBloc>().state;
    if (state is PromotionsInitial) {
      context.read<PromotionsBloc>().add(const LoadPromotions());
    }
  }

  void _onAddPromotion() {
    Navigator.pushNamed(context, EditPromotionScreen.routeName,
        arguments: null);
  }
}
