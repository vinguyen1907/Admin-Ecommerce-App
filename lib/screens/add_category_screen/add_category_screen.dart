import 'package:admin_ecommerce_app/blocs/add_category_screen_bloc/add_category_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/image_picker_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/image_picker_utils.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});
  static const String routeName = '/add-category-screen';
  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController = TextEditingController();
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddCategoryScreenBloc>().add(const LoadAddCategoryScreen());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const ScreenNameSection("Create Category",
                    hasDefaultBackButton: true, margin: EdgeInsets.zero),
                BlocListener<AddCategoryScreenBloc, AddCategoryScreenState>(
                    listener: (context, state) {
                      if (state is AddingCategory) {
                        Utils().showDialogLoading(context);
                      }
                      if (state is AddSuccessful) {
                        Navigator.of(context, rootNavigator: true).pop();
                        _showSubmitSuccessful();
                      }
                    },
                    child: PrimaryBackground(
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
                                  height: size.width * 0.35 * 1.3,
                                  width: size.width * 0.35,
                                  image: _image,
                                  onTap: _addImage,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MyElevatedButton(
                                  onPressed: () => _addCategory(),
                                  widget: const Text('Submit')),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addImage() async {
    Uint8List? image = await ImagePickerUtils.openFilePicker(context);
    setState(() {
      _image = image;
    });
  }

  _showSubmitSuccessful() {
    Utils().showSuccessful(
        context: context,
        title: 'Submit successfully',
        desc: 'You have successfully created a new category',
        btnOkOnPress: _clearForm);
  }

  _addCategory() async {
    if (_image == null) {
      Utils().showFail(
          context: context,
          title: 'Image is empty',
          desc: 'Please select an image',
          btnCancelOnPress: () {},
          btnOkOnPress: _addImage);
    }
    if (_formKey.currentState!.validate()) {
      context
          .read<AddCategoryScreenBloc>()
          .add(AddCategory(_image!, _nameController.text.trim()));
    }
  }

  _clearForm() {
    setState(() {
      _image = null;
    });
    _nameController.clear();
  }
}
