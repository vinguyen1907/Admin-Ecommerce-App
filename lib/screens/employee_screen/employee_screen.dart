import 'package:admin_ecommerce_app/common_widgets/my_app_bar.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/employee_screen/widgets/employee_table.dart';
import 'package:flutter/material.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  static const String routeName = "employee_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? const MyAppBar() : null,
      body: SafeArea(
          child: ScreenHorizontalPaddingWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenNameSection("Employee"),
            EmployeeTable(),
          ],
        ),
      )),
    );
  }
}
