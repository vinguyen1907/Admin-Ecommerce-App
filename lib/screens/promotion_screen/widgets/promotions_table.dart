import 'package:admin_ecommerce_app/blocs/promotions_bloc/promotions_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/edit_promotion_screen/edit_promotion_screen.dart';
import 'package:admin_ecommerce_app/screens/promotion_screen/widgets/promotion_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionsTable extends StatelessWidget {
  final List<Promotion> promotions;
  final bool isLoading;
  const PromotionsTable({
    super.key,
    required this.promotions,
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
                  ? 50
                  : Responsive.isTablet(context)
                      ? 30
                      : 10,
              columns: const <DataColumn>[
                DataColumn(label: Text("#")),
                DataColumn(label: Text("Code")),
                DataColumn(
                    label: Text("Content", overflow: TextOverflow.ellipsis)),
                DataColumn(label: Text("Start Time")),
                DataColumn(label: Text("End Time")),
                // DataColumn(label: Text("Type")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Usage")),
                DataColumn(label: SizedBox()),
              ],
              rows: List.generate(promotions.length, (index) {
                final promotion = promotions[index];
                return DataRow(
                    cells: <DataCell>[
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(
                        promotion.code,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        promotion.content,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        promotion.startTime.toDateTimeFormat(),
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        promotion.endTime.toDateTimeFormat(),
                        overflow: TextOverflow.ellipsis,
                      )),
                      // DataCell(Text(
                      //   promotion.type.toPromotionString(),
                      //   overflow: TextOverflow.ellipsis,
                      // )),
                      DataCell(
                        Text(
                          promotion.amountString,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DataCell(
                        Text(
                          "${promotion.usedQuantity}/${promotion.quantity}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DataCell(Row(
                        children: [
                          IconButton(
                              onPressed: () => _onEditPromotion(
                                  context: context, promotion: promotion),
                              icon: const MyIcon(
                                icon: AppAssets.icEdit,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.srcIn),
                              )),
                          IconButton(
                              onPressed: () => _onDeletePromotion(
                                  context: context, promotion: promotion),
                              icon: const MyIcon(
                                icon: AppAssets.icDelete,
                                colorFilter: ColorFilter.mode(
                                    Colors.red, BlendMode.srcIn),
                              )),
                        ],
                      )),
                    ],
                    onSelectChanged: (isSelected) {
                      if (isSelected!) {
                        _onShowPromotion(
                            context: context, promotion: promotion);
                      }
                    });
              }),
            ),
          );
  }

  void _onShowPromotion(
      {required BuildContext context, required Promotion promotion}) {
    showDialog(
        context: context,
        builder: (_) {
          return PromotionDetailDialog(promotion: promotion);
        });
  }

  void _onEditPromotion(
      {required BuildContext context, required Promotion promotion}) {
    Navigator.pushNamed(context, EditPromotionScreen.routeName,
        arguments: promotion);
  }

  void _onDeletePromotion(
      {required BuildContext context, required Promotion promotion}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: AppColors.whiteColor,
            title: const Text("Delete Promotion"),
            content: const Text("Are you sure to delete this promotion?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text("Cancel", style: AppStyles.bodyMedium)),
              TextButton(
                  onPressed: () {
                    context
                        .read<PromotionsBloc>()
                        .add(DeletePromotion(promotion: promotion));
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text("Delete",
                      style: AppStyles.bodyMedium.copyWith(color: Colors.red))),
            ],
          );
        });
  }
}
