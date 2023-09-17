import 'package:admin_ecommerce_app/blocs/edit_product_screen_bloc/edit_product_screen_bloc.dart';
import 'package:admin_ecommerce_app/blocs/product_screen_bloc/product_screen_bloc.dart';
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
import 'package:admin_ecommerce_app/screens/add_product_detail_screen/add_product_detail_screen.dart';
import 'package:admin_ecommerce_app/screens/add_product_stock_screen/add_product_stock_screen.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:flutter/material.dart';
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
                    } else if (state is EditProductScreenLoaded ||
                        state is Updating ||
                        state is UpdateSuccessful) {
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Responsive.isMobile(context)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  MyElevatedButton(
                                                      onPressed: () =>
                                                          _navigateAddProductStock(),
                                                      widget:
                                                          const Text('Import')),
                                                  MyElevatedButton(
                                                      onPressed: () =>
                                                          _navigateAddProductDetail(),
                                                      widget: const Text(
                                                          'Add Product Detail')),
                                                  MyElevatedButton(
                                                      onPressed: () =>
                                                          _updateProduct(),
                                                      widget:
                                                          const Text('Update')),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  MyElevatedButton(
                                                      onPressed: () =>
                                                          _navigateAddProductStock(),
                                                      widget:
                                                          const Text('Import')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  MyElevatedButton(
                                                      onPressed: () =>
                                                          _navigateAddProductDetail(),
                                                      widget: const Text(
                                                          'Add Product Detail')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  MyElevatedButton(
                                                      onPressed: () =>
                                                          _updateProduct(),
                                                      widget:
                                                          const Text('Update')),
                                                ],
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
                      (BuildContext context, EditProductScreenState state) {
                    if (state is Updating) {
                      Utils().showDialogLoading(context);
                    }
                    if (state is UpdateSuccessful) {
                      _showUpdateSuccessful();
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
        .read<EditProductScreenBloc>()
        .add(ChangeCategoryEditProductScreen(category: value!));
  }

  Future<void> _addImage() async {
    context.read<EditProductScreenBloc>().add(ChangeImage(context: context));
  }

  _showUpdateSuccessful() {
    Navigator.of(context, rootNavigator: true).pop();
    context.read<ProductScreenBloc>().add(const LoadProducts());
    Utils().showSuccessful(
        context: context,
        title: 'Update successfully',
        desc: 'You have successfully updated a product',
        btnOkOnPress: () {
          Navigator.pop(context);
        });
  }

  _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      context.read<EditProductScreenBloc>().add(Update(
            name: _nameController.text,
            brand: _brandController.text,
            price: _priceController.text,
            description: _desController.text,
            id: widget.product.id,
          ));
    }
  }

  _navigateAddProductDetail() {
    Navigator.pushNamed(context, AddProductDetailScreen.routeName,
        arguments: widget.product);
  }

  _navigateAddProductStock() {
    Navigator.pushNamed(context, AddProductStockScreen.routeName,
        arguments: widget.product);
  }
}
