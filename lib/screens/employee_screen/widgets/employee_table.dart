import 'package:admin_ecommerce_app/blocs/employees_bloc/employees_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_datatable.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/repositories/user_repository.dart';
import 'package:admin_ecommerce_app/screens/edit_employee_screen/edit_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      builder: (context, state) {
        if (state is EmployeesLoading) {
          return const Center(child: CustomLoadingWidget());
        }
        if (state is EmployeesError) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is EmployeesLoaded) {
          final List<Employee> employees = state.employees;
          return PrimaryBackground(
              child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: MyElevatedButton(
                    onPressed: () =>
                        _navigateToEditEmployeeScreen(context: context),
                    widget: const Text("Add New")),
              ),
              MyDataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text("#")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Date of birth")),
                    DataColumn(label: Text("Salary")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("")),
                  ],
                  rows: List.generate(employees.length, (index) {
                    final Employee employee = employees[index];
                    return DataRow(cells: [
                      DataCell(
                        Text((index + 1).toString()),
                      ),
                      DataCell(
                        Text(employee.name),
                      ),
                      DataCell(
                        Text(employee.email),
                      ),
                      DataCell(
                        Text(employee.dateOfBirth.toDateFormat()),
                      ),
                      DataCell(
                        Text(employee.salary.toPriceString()),
                      ),
                      DataCell(
                        Text(employee.workingStatus.name),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => _onEditEmployee(
                                    context: context, employee: employee),
                                icon: const MyIcon(icon: AppAssets.icEdit)),
                            IconButton(
                                onPressed: () =>
                                    _onDeleteEmployee(employeeId: employee.id),
                                icon: const MyIcon(
                                  icon: AppAssets.icDelete,
                                  colorFilter: ColorFilter.mode(
                                      Colors.red, BlendMode.srcIn),
                                )),
                          ],
                        ),
                      ),
                    ]);
                  })),
            ],
          ));
        }
        return Container();
      },
    );
  }

  void _onEditEmployee(
      {required BuildContext context, required Employee employee}) {
    _navigateToEditEmployeeScreen(context: context, employee: employee);
  }

  void _onDeleteEmployee({required String employeeId}) async {
    await UserRepository().deleteEmployee(id: employeeId);
    if (!mounted) return;
    context.read<EmployeesBloc>().add(ReloadEmployees());
  }

  void _navigateToEditEmployeeScreen(
      {required BuildContext context, Employee? employee}) {
    Navigator.pushNamed(context, EditEmployeeScreen.routeName,
        arguments: employee);
  }

  void _loadData() {
    final state = context.read<EmployeesBloc>().state;
    if (state is EmployeesInitial) {
      context.read<EmployeesBloc>().add(LoadEmployees());
    }
  }
}
