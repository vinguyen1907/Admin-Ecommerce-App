import 'package:admin_ecommerce_app/blocs/add_product_stock_screen_bloc/add_product_stock_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_drop_down_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/string_extensions.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/models/product_detail.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:admin_ecommerce_app/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductStockScreen extends StatefulWidget {
  const AddProductStockScreen({super.key, required this.product});

  final Product product;
  static const String routeName = '/add-product-stock-screen';

  @override
  State<AddProductStockScreen> createState() => _AddProductStockScreenState();
}

class _AddProductStockScreenState extends State<AddProductStockScreen> {
  final _stockController = TextEditingController();
  final _importController = TextEditingController();
  Color? currentColor;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<AddProductStockScreenBloc>()
        .add(LoadProductDetails(product: widget.product));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductStockScreenBloc, AddProductStockScreenState>(
      listener: (context, state) {
        if (state is Importing) {
          Utils().showDialogLoading(context);
        }
        if (state is ImportSuccessful) {
          Navigator.of(context, rootNavigator: true).pop();
          _showSubmitSuccessful();
        }
      },
      builder: (context, state) {
        if (state is AddProductStockScreenLoading) {
          return const CustomLoadingWidget();
        }
        if (state is! AddProductStockScreenInitial) {
          _stockController.text = state.productDetailSelected!.stock.toString();
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const ScreenNameSection("Add Product Stock",
                          hasDefaultBackButton: true, margin: EdgeInsets.zero),
                      ScreenHorizontalPaddingWidget(
                        child: PrimaryBackground(
                          margin: Responsive.isDesktop(context)
                              ? EdgeInsets.zero
                              : const EdgeInsets.symmetric(
                                  horizontal: AppDimensions
                                      .mobileHorizontalContentPadding),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions
                                    .mobileHorizontalContentPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                MyDropDownButton<ProductDetail>(
                                    label: 'Size',
                                    value: state.productDetailSelected,
                                    onChanged: (value) =>
                                        _onChangeProductDetail(value),
                                    items: state.productDetails
                                        .map<DropdownMenuItem<ProductDetail>>(
                                            (ProductDetail value) {
                                      return DropdownMenuItem<ProductDetail>(
                                        value: value,
                                        child: Text(
                                          value.size!,
                                          style: AppStyles.titleSmall,
                                        ),
                                      );
                                    }).toList()),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Color',
                                      style: AppStyles.headlineMedium,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: state
                                          .productDetailSelected!.color!
                                          .toColor(),
                                      radius: 20,
                                    )
                                  ],
                                ),
                                MyTextFormField(
                                  enabled: false,
                                  controller: _stockController,
                                  hintText: 'Stock',
                                  label: 'Stock',
                                  validator: ValidatorUtils.validateText,
                                ),
                                MyTextFormField(
                                  controller: _importController,
                                  hintText: 'Import',
                                  label: 'Import',
                                  validator: ValidatorUtils.validateText,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: MyElevatedButton(
                                      onPressed: () => _import(),
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
        } else {
          return const SizedBox();
        }
      },
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

  _import() async {
    if (_formKey.currentState!.validate()) {
      context.read<AddProductStockScreenBloc>().add(Import(
          quantity: _importController.text.trim(), product: widget.product));
    }
  }

  _onChangeProductDetail(ProductDetail? productDetail) {
    context
        .read<AddProductStockScreenBloc>()
        .add(ChangeProductDetail(productDetail: productDetail!));
  }
}
