import 'package:admin_ecommerce_app/blocs/add_product_screen_bloc/add_product_screen_bloc.dart';
import 'package:admin_ecommerce_app/blocs/edit_product_screen_bloc/edit_product_screen_bloc.dart';
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
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/image_picker_utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});
  static const String routeName = '/edit-product-screen';
  final Product product;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _desController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.product.name;
    _brandController.text = widget.product.brand;
    _priceController.text = widget.product.price.toString();
    _desController.text = widget.product.description;
    context
        .read<EditProductScreenBloc>()
        .add(LoadEditProductScreen(product: widget.product));
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
                const ScreenNameSection("Edit Product",
                    hasDefaultBackButton: true, margin: EdgeInsets.zero),
                BlocConsumer<EditProductScreenBloc, EditProductScreenState>(
                  builder: (context, state) {
                    if (state is EditProductScreenLoading) {
                      return const CustomLoadingWidget();
                    } else if (state is EditProductScreenLoaded) {
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
                                          image: state.imageSelected,
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
                                                    image: state.imageSelected,
                                                    onTap: _addImage,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        // const Spacer(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: MyElevatedButton(
                                              onPressed: () {},
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
                  listener:
                      (BuildContext context, EditProductScreenState state) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onChangeCategory(Category? value) {
    context.read<EditProductScreenBloc>().add(ChangeCategory(category: value!));
  }

  Future<void> _addImage() async {
    context.read<EditProductScreenBloc>().add(ChangeImage(context: context));
  }

  _showSubmitSuccessful() {
    Size size = MediaQuery.of(context).size;
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      width: size.width * 0.35,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Submit successfully',
      desc: 'You have successfully created a new product',
      btnOkOnPress: () {
        _clearForm();
      },
    ).show();
  }

  _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      // context.read<EditProductScreenBloc>().add(Submit(
      //     image: _image!,
      //     name: _nameController.text,
      //     brand: _brandController.text,
      //     price: _priceController.text,
      //     description: _desController.text));
    }
  }

  _clearForm() {
    _nameController.clear();
    _brandController.clear();
    _priceController.clear();
    _desController.clear();
  }
}
