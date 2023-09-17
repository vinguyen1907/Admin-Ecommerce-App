import 'package:admin_ecommerce_app/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:admin_ecommerce_app/blocs/edit_category_screen_bloc/edit_category_screen_bloc.dart';
import 'package:admin_ecommerce_app/blocs/edit_category_screen_bloc/edit_category_screen_event.dart';
import 'package:admin_ecommerce_app/blocs/edit_category_screen_bloc/edit_category_screen_state.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/image_picker_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key, required this.category});
  final Category category;
  static const String routeName = '/edit-category-screen';
  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.category.name;
    context
        .read<EditCategoryScreenBloc>()
        .add(LoadEditCategoryScreen(category: widget.category));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<EditCategoryScreenBloc, EditCategoryScreenState>(
      listener: (context, state) {
        if (state is Updating) {
          Utils().showDialogLoading(context);
        }
        if (state is UpdateSuccessful) {
          _showUpdateSuccessful();
        }
      },
      builder: (context, state) {
        if (state is EditCategoryScreenLoading) {
          return const CustomLoadingWidget();
        }
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const ScreenNameSection("Edit Category",
                        hasDefaultBackButton: true, margin: EdgeInsets.zero),
                    PrimaryBackground(
                      margin: Responsive.isDesktop(context)
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(
                              horizontal:
                                  AppDimensions.mobileHorizontalContentPadding),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                AppDimensions.mobileHorizontalContentPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            MyTextFormField(
                              controller: _nameController,
                              hintText: 'Category name',
                              label: 'Category name',
                              validator: ValidatorUtils.validateText,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Image',
                                  style: AppStyles.headlineMedium,
                                ),
                                ImagePickerWidget(
                                  height: size.width * 0.1 * 1.3,
                                  width: size.width * 0.1,
                                  image: state.imageSelected,
                                  onTap: _addImage,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MyElevatedButton(
                                  onPressed: () => _updateCategory(),
                                  widget: const Text('Update')),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addImage() async {
    context.read<EditCategoryScreenBloc>().add(ChangeImage(context: context));
  }

  _showUpdateSuccessful() {
    Navigator.of(context, rootNavigator: true).pop();
    context.read<CategoryScreenBloc>().add(const LoadCategories());
    Utils().showSuccessful(
        context: context,
        title: 'Update successfully',
        desc: 'You have successfully updated a category',
        btnOkOnPress: () {
          Navigator.pop(context);
        });
  }

  _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      context.read<EditCategoryScreenBloc>().add(Update(
            name: _nameController.text,
            id: widget.category.id,
          ));
    }
  }
}
