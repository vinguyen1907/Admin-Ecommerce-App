import 'dart:typed_data';

import 'package:admin_ecommerce_app/blocs/employees_bloc/employees_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/loading_manager.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/common_widgets/text_field_label.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/working_status_extension.dart';
import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/repositories/user_repository.dart';
import 'package:admin_ecommerce_app/screens/edit_employee_screen/edit_employee_form_validators.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({
    super.key,
    this.employee,
  });

  final Employee? employee;

  static const String routeName = "edit-employee-screen";

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  String screenName = "";
  Uint8List? imageBytes;
  DateTime dateOfBirth = DateTime.now();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController =
      TextEditingController(text: DateTime.now().toDateFormat());
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  WorkingStatus workingStatus = WorkingStatus.working;
  bool isLoading = false;
  bool resetPassword = false;

  @override
  void initState() {
    super.initState();
    if (widget.employee == null) {
      screenName = "Add Employee";
    } else {
      screenName = "Edit Employee";
    }

    _initValues();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _salaryController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: ScreenHorizontalPaddingWidget(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ScreenNameSection(
                      screenName,
                      hasDefaultBackButton: true,
                    ),
                    PrimaryBackground(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: _onPickImage,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          AppDimensions.roundedCorners,
                                      image: imageBytes != null
                                          ? DecorationImage(
                                              image: MemoryImage(imageBytes!),
                                              fit: BoxFit.cover,
                                            )
                                          : widget.employee != null &&
                                                  widget.employee!.imgUrl !=
                                                      null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      widget.employee!.imgUrl!),
                                                  fit: BoxFit.cover,
                                                )
                                              : const DecorationImage(
                                                  image: AssetImage(AppAssets
                                                      .imgDefaultAvatar),
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                const TextFieldLabel("Phone", isRequired: true),
                                MyTextField(
                                  controller: _phoneController,
                                  hintText: "Phone",
                                  validator:
                                      EditEmployeeFormValidators.phoneValidator,
                                ),
                                const TextFieldLabel("Email", isRequired: true),
                                MyTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                  validator:
                                      EditEmployeeFormValidators.emailValidator,
                                ),
                                if (widget.employee == null)
                                  const TextFieldLabel("Password",
                                      isRequired: true),
                                if (widget.employee == null)
                                  MyTextField(
                                    controller: _passwordController,
                                    hintText: "Password",
                                    validator: EditEmployeeFormValidators
                                        .passwordValidator,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextFieldLabel("Name", isRequired: true),
                                MyTextField(
                                  controller: _nameController,
                                  hintText: "Name",
                                  validator:
                                      EditEmployeeFormValidators.nameValidator,
                                ),
                                const TextFieldLabel("Date of birth",
                                    isRequired: true),
                                MyTextField(
                                  controller: _dateOfBirthController,
                                  hintText: "Date of birth",
                                  readOnly: true,
                                  suffixIcon: IconButton(
                                      onPressed: _onPickDateOfBirth,
                                      icon: const MyIcon(
                                          icon: AppAssets.icCalendar)),
                                ),
                                const TextFieldLabel("Address",
                                    isRequired: true),
                                MyTextField(
                                  controller: _addressController,
                                  hintText: "Address",
                                  validator: EditEmployeeFormValidators
                                      .addressValidator,
                                ),
                                const TextFieldLabel("Salary (\$)",
                                    isRequired: true),
                                MyTextField(
                                  controller: _salaryController,
                                  hintText: "Salary",
                                  validator: EditEmployeeFormValidators
                                      .salaryValidator,
                                ),
                                const TextFieldLabel("Working status"),
                                Container(
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppColors.greyColor)),
                                  child: DropdownButton<WorkingStatus>(
                                      isExpanded: true,
                                      icon: const MyIcon(
                                          icon: AppAssets.icArrowDown),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      borderRadius: BorderRadius.circular(8),
                                      underline: const SizedBox(),
                                      itemHeight: 48,
                                      isDense: true,
                                      value: workingStatus,
                                      items: WorkingStatus.values
                                          .map((e) =>
                                              DropdownMenuItem<WorkingStatus>(
                                                  value: e,
                                                  child: Text(e.title)))
                                          .toList(),
                                      onChanged: (value) =>
                                          _onSelectPromotionType(value)),
                                ),
                                const SizedBox(height: 12),
                                if (widget.employee != null)
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: resetPassword,
                                          onChanged: (value) {
                                            setState(() {
                                              resetPassword = value!;
                                            });
                                          }),
                                      const Text("Reset password")
                                    ],
                                  ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: MyElevatedButton(
                                      onPressed: _onSubmit,
                                      widget: Text(widget.employee == null
                                          ? "Add"
                                          : "Edit")),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _initValues() {
    if (widget.employee != null) {
      _emailController.text = widget.employee!.email;
      _nameController.text = widget.employee!.name;
      _addressController.text = widget.employee!.address;
      _phoneController.text = widget.employee!.phone;
      _dateOfBirthController.text = widget.employee!.dateOfBirth.toDateFormat();
      _salaryController.text = widget.employee!.salary.toString();
      workingStatus = widget.employee!.workingStatus;
    }
  }

  _onSelectPromotionType(WorkingStatus? workingStatus) {
    if (workingStatus != null) {
      setState(() {
        this.workingStatus = workingStatus;
      });
    }
  }

  Future<void> _onPickImage() async {
    final Uint8List? image = await Utils().pickImage();
    setState(() {
      imageBytes = image;
    });
  }

  Future<void> _onPickDateOfBirth() async {
    DateTime? newDate = await Utils.showMyDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));
    if (newDate != null) {
      setState(() {
        dateOfBirth = newDate;
        _dateOfBirthController.text = newDate.toDateFormat();
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (widget.employee == null) {
        await _onAddEmployee();
      } else {
        await _onEditEmployee();
      }

      if (!mounted) return;
      context.read<EmployeesBloc>().add(ReloadEmployees());
    }
  }

  Future<void> _onAddEmployee() async {
    _changeLoadingStatus(true);

    final Employee employee = Employee(
      id: "",
      email: _emailController.text,
      type: UserType.employee,
      name: _nameController.text,
      dateOfBirth: dateOfBirth,
      salary: double.parse(_salaryController.text),
      workingStatus: workingStatus,
      imgUrl: null,
      address: _addressController.text,
      phone: _phoneController.text,
    );
    await UserRepository().addEmployees(
        employee: employee,
        password: _passwordController.text,
        image: imageBytes);

    _changeLoadingStatus(false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _onEditEmployee() async {
    _changeLoadingStatus(true);

    final Employee employee = Employee(
      id: widget.employee!.id,
      email: _emailController.text,
      type: UserType.employee,
      name: _nameController.text,
      dateOfBirth: dateOfBirth,
      salary: double.parse(_salaryController.text),
      workingStatus: workingStatus,
      imgUrl: widget.employee!.imgUrl,
      address: _addressController.text,
      phone: _phoneController.text,
    );
    await UserRepository().updateEmployee(
        employee: employee, resetPassword: resetPassword, image: imageBytes);

    _changeLoadingStatus(false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _changeLoadingStatus(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
