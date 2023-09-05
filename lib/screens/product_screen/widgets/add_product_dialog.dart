import 'dart:io';

import 'package:admin_ecommerce_app/blocs/product_screen_bloc/product_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_drop_down_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/category.dart' as category;
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static const String routeName = '/add-product-screen';
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  Uint8List? _image;
  category.Category? categorySelected;
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ProductScreenBloc, ProductScreenState>(
      builder: (context, state) {
        final currentState = state as ProductScreenLoaded;
        categorySelected ??= currentState.categories.first;
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              // height: size.height - MediaQuery.of(context).viewPadding.top,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.defaultHorizontalContentPadding,
                  vertical: 15),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Form(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Responsive.isDesktop(context)
                        ? Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Image',
                                  style: AppStyles.headlineMedium,
                                ),
                                GestureDetector(
                                  onTap: () => openFilePicker(),
                                  child: Container(
                                    height: size.width * 0.1 * 1.3,
                                    width: size.width * 0.1,
                                    decoration: BoxDecoration(
                                        image: _image != null
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                  _image!,
                                                ),
                                                fit: BoxFit.cover)
                                            : null,
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.greyColor),
                                    child: _image == null
                                        ? const Center(
                                            child: Icon(
                                              Icons.image,
                                              color: AppColors.greyTextColor,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyTextFormField(
                            controller: _nameController,
                            hintText: 'Product name',
                            label: 'Product name',
                          ),
                          MyTextFormField(
                            controller: _brandController,
                            hintText: 'Product brand',
                            label: 'Product brand',
                          ),
                          MyTextFormField(
                            controller: _priceController,
                            hintText: 'Product price',
                            label: 'Product price',
                          ),
                          MyDropDownButton<category.Category>(
                              label: 'Category',
                              value: categorySelected,
                              onChanged: (value) => _onChangeCategory(value),
                              items: currentState.categories
                                  .map<DropdownMenuItem<category.Category>>(
                                      (category.Category value) {
                                return DropdownMenuItem<category.Category>(
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
                            maxLines: 4,
                          ),
                          Responsive.isMobile(context)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Image',
                                      style: AppStyles.headlineMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () => openFilePicker(),
                                      child: Container(
                                        height: size.width * 0.4 * 1.3,
                                        width: size.width * 0.4,
                                        decoration: BoxDecoration(
                                            image: _image != null
                                                ? DecorationImage(
                                                    image: MemoryImage(
                                                      _image!,
                                                    ),
                                                    fit: BoxFit.cover)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.greyColor),
                                        child: _image == null
                                            ? const Center(
                                                child: Icon(
                                                  Icons.image,
                                                  color:
                                                      AppColors.greyTextColor,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
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
            ),
          ),
        );
      },
    );
  }

  _onChangeCategory(category.Category? value) {
    setState(() {
      categorySelected = value!;
    });
  }

  Future<void> openFilePicker() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      final Uint8List temp = await image!.readAsBytes();
      setState(() {
        _image = temp;
      });
    } catch (e) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (!context.mounted) return;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Storage Access Required'),
              content: const Text(
                  'To use storage features, please grant storage access.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: AppStyles.labelMedium,
                    )),
                TextButton(
                    onPressed: () async {
                      await openAppSettings();
                    },
                    child: const Text(
                      'Open settings',
                      style: AppStyles.labelMedium,
                    )),
              ],
            );
          },
        );
      }
    }
  }

  _addProduct() async {
    await ProductRepository().addProduct(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _desController.text.trim(),
        category: categorySelected!,
        image: _image!);
    if (!context.mounted) return;
    Navigator.pop(context);
    context.read<ProductScreenBloc>().add(const LoadProducts());
  }
}
