import 'package:admin_ecommerce_app/blocs/add_product_screen_bloc/add_product_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/image_picker_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_drop_down_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/image_picker_utils.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static const String routeName = '/add-product-screen';
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _desController = TextEditingController();
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddProductScreenBloc>().add(const LoadCategories());
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
                const ScreenNameSection("Create Product",
                    hasDefaultBackButton: true, margin: EdgeInsets.zero),
                BlocConsumer<AddProductScreenBloc, AddProductScreenState>(
                  builder: (context, state) {
                    if (state is AddProductScreenLoading) {
                      return const CustomLoadingWidget();
                    } else if (state is AddProductScreenLoaded ||
                        state is SubmitSuccessful ||
                        state is Submitting) {
                      return PrimaryBackground(
                        margin: Responsive.isDesktop(context)
                            ? EdgeInsets.zero
                            : const EdgeInsets.symmetric(
                                horizontal: AppDimensions
                                    .mobileHorizontalContentPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Responsive.isDesktop(context)
                                ? Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Image',
                                          style: AppStyles.headlineMedium,
                                        ),
                                        ImagePickerWidget(
                                          height: size.width * 0.1 * 1.3,
                                          width: size.width * 0.1,
                                          image: _image,
                                          onTap: _addImage,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Responsive.isDesktop(context)
                                ? const SizedBox(
                                    width: 15,
                                  )
                                : const SizedBox(),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimensions
                                            .mobileHorizontalContentPadding),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MyTextFormField(
                                          controller: _nameController,
                                          hintText: 'Product name',
                                          label: 'Product name',
                                          validator:
                                              ValidatorUtils.validateText,
                                        ),
                                        MyTextFormField(
                                          controller: _brandController,
                                          hintText: 'Product brand',
                                          label: 'Product brand',
                                          validator:
                                              ValidatorUtils.validateText,
                                        ),
                                        MyTextFormField(
                                          controller: _priceController,
                                          hintText: 'Product price',
                                          label: 'Product price',
                                          validator:
                                              ValidatorUtils.validatePrice,
                                        ),
                                        MyDropDownButton<Category>(
                                            label: 'Category',
                                            value: state.categorySelected,
                                            onChanged: (value) =>
                                                _onChangeCategory(value),
                                            items: state.categories!.map<
                                                    DropdownMenuItem<Category>>(
                                                (Category value) {
                                              return DropdownMenuItem<Category>(
                                                value: value,
                                                child: Text(
                                                  value.name,
                                                  style: AppStyles.titleSmall,
                                                ),
                                              );
                                            }).toList()),
                                        MyTextFormField(
                                          controller: _desController,
                                          hintText: 'Product description',
                                          label: 'Product description',
                                          validator:
                                              ValidatorUtils.validateText,
                                          maxLines: 4,
                                        ),
                                        Responsive.isMobile(context)
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Image',
                                                    style: AppStyles
                                                        .headlineMedium,
                                                  ),
                                                  ImagePickerWidget(
                                                    height:
                                                        size.width * 0.1 * 1.3,
                                                    width: size.width * 0.1,
                                                    image: _image,
                                                    onTap: _addImage,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        // const Spacer(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: MyElevatedButton(
                                              onPressed: () => _addProduct(),
                                              widget: const Text('Submit')),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  listener: (_, AddProductScreenState state) {
                    if (state is SubmitSuccessful) {
                      Navigator.of(context, rootNavigator: true).pop();
                      _showSubmitSuccessful();
                    }
                    if (state is Submitting) {
                      Utils().showDialogLoading(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onChangeCategory(Category? value) {
    context
        .read<AddProductScreenBloc>()
        .add(ChangeCategorySelected(categorySelected: value!));
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
        desc: 'You have successfully created a new product',
        btnOkOnPress: _clearForm);
  }

  _addProduct() async {
    if (_image == null) {
      Utils().showFail(
          context: context,
          title: 'Image is empty',
          desc: 'Please select an image',
          btnCancelOnPress: () {},
          btnOkOnPress: _addImage);
    }
    if (_formKey.currentState!.validate()) {
      context.read<AddProductScreenBloc>().add(Submit(
          image: _image!,
          name: _nameController.text,
          brand: _brandController.text,
          price: _priceController.text,
          description: _desController.text));
    }
  }

  _clearForm() {
    setState(() {
      _image = null;
    });
    _nameController.clear();
    _brandController.clear();
    _priceController.clear();
    _desController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _desController.dispose();
  }
}
