import 'package:admin_ecommerce_app/blocs/add_category_screen_bloc/add_category_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddProductDetailScreen extends StatefulWidget {
  const AddProductDetailScreen({super.key, required this.product});
  final Product product;
  static const String routeName = '/add-product-detail-screen';
  @override
  State<AddProductDetailScreen> createState() => _AddProductDetailScreenState();
}

class _AddProductDetailScreenState extends State<AddProductDetailScreen> {
  final _sizeController = TextEditingController();
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddCategoryScreenBloc>().add(const LoadAddCategoryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const ScreenNameSection("Create Product Detail",
                    hasDefaultBackButton: true, margin: EdgeInsets.zero),
                ScreenHorizontalPaddingWidget(
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
                            controller: _sizeController,
                            hintText: 'Size',
                            label: 'Size',
                            validator: ValidatorUtils.validateText,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Color',
                                style: AppStyles.headlineMedium,
                              ),
                              GestureDetector(
                                onTap: () => chooseColor(),
                                child: CircleAvatar(
                                  backgroundColor: currentColor,
                                  radius: 20,
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MyElevatedButton(
                                onPressed: () => _addProductDetail(),
                                widget: const Text('Submit')),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void chooseColor() {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: HueRingPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            displayThumbColor: true,
            enableAlpha: false,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }

  _showSubmitSuccessful() {
    Utils().showSuccessful(
        context: context,
        title: 'Submit successfully',
        desc: 'You have successfully created a new product detail',
        btnOkOnPress: () {
          Navigator.pop(context);
        });
  }

  _addProductDetail() async {
    if (_formKey.currentState!.validate()) {
      Utils().showDialogLoading(context);
      await ProductRepository().addProductDetail(
          productId: widget.product.id,
          color: currentColor,
          size: _sizeController.text.trim());
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _showSubmitSuccessful();
    }
  }
}
