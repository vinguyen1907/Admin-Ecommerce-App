import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:flutter/material.dart';

class MyDataTable extends StatelessWidget {
  const MyDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingTextStyle: AppStyles.tableColumnName
            .copyWith(fontSize: !Responsive.isDesktop(context) ? 12 : null),
        dataTextStyle: AppStyles.tableCell
            .copyWith(fontSize: !Responsive.isDesktop(context) ? 12 : null),
        columnSpacing: Responsive.isDesktop(context)
            ? 80
            : Responsive.isTablet(context)
                ? 30
                : 10,
        columns: columns,
        rows: rows,
      ),
    );
  }
}
