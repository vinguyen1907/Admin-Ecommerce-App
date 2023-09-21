import 'dart:typed_data';

import 'package:admin_ecommerce_app/blocs/promotions_bloc/promotions_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/loading_manager.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/common_widgets/text_field_label.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/promotion_type_extensions.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/models/promotion_type.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPromotionScreen extends StatefulWidget {
  const EditPromotionScreen({super.key, required this.promotion});

  final Promotion? promotion;

  static const String routeName = "/edit-promotion-screen";

  @override
  State<EditPromotionScreen> createState() => _EditPromotionScreenState();
}

class _EditPromotionScreenState extends State<EditPromotionScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  DateTime? startTime;
  DateTime? endTime;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _maxDiscountController = TextEditingController();
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Uint8List? imageBytes;
  PromotionType promotionType = PromotionType.freeShipping;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _contentController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _maxDiscountController.dispose();
    _minValueController.dispose();
    _discountAmountController.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LoadingManager(
      isLoading: context.watch<PromotionsBloc>().state is UpdatingPromotion,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: Responsive.isDesktop(context)
                ? size.width * 0.4
                : size.width - 40,
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ScreenNameSection("Edit Promotion",
                        hasDefaultBackButton: true),
                    PrimaryBackground(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextFieldLabel("Code", isRequired: true),
                            MyTextField(
                              controller: _codeController,
                              hintText: "Code",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Code is required";
                                }
                                return null;
                              },
                            ),
                            const TextFieldLabel("Content", isRequired: true),
                            MyTextField(
                              controller: _contentController,
                              hintText: "Content",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Content is required";
                                }
                                return null;
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel("Start",
                                          isRequired: true),
                                      MyTextField(
                                        controller: _startDateController,
                                        hintText: "Start time",
                                        readOnly: true,
                                        suffixIcon: IconButton(
                                            onPressed: _onPickStartTime,
                                            icon: const MyIcon(
                                                icon: AppAssets.icCalendar)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Start time is required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel("End",
                                          isRequired: true),
                                      MyTextField(
                                        controller: _endDateController,
                                        hintText: "End time",
                                        readOnly: true,
                                        suffixIcon: IconButton(
                                            onPressed: _onPickEndTime,
                                            icon: const MyIcon(
                                                icon: AppAssets.icCalendar)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "End time is required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const TextFieldLabel("Image", isRequired: true),
                            InkWell(
                              onTap: _onPickImage,
                              child: Container(
                                height: 150,
                                width: widget.promotion == null &&
                                        imageBytes == null
                                    ? 150
                                    : 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  image: imageBytes != null
                                      ? DecorationImage(
                                          image: MemoryImage(imageBytes!),
                                          fit: BoxFit.cover,
                                        )
                                      : widget.promotion != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  widget.promotion!.imgUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                ),
                                alignment: Alignment.center,
                                child: widget.promotion == null &&
                                        imageBytes == null
                                    ? const MyIcon(
                                        icon: AppAssets.icGalleryExport,
                                        height: 30)
                                    : null,
                              ),
                            ),
                            const TextFieldLabel("Maximum discount (\$)"),
                            MyTextField(
                              controller: _maxDiscountController,
                              hintText: "Maximum discount",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return "Not number type";
                                }
                                return null;
                              },
                            ),
                            const TextFieldLabel("Minimum order value (\$)"),
                            MyTextField(
                              controller: _minValueController,
                              hintText: "Minimum order value",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return "Not number type";
                                }
                                return null;
                              },
                            ),
                            const TextFieldLabel("Type", isRequired: true),
                            Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: AppColors.greyColor)),
                              child: DropdownButton<PromotionType>(
                                  isExpanded: true,
                                  icon:
                                      const MyIcon(icon: AppAssets.icArrowDown),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  borderRadius: BorderRadius.circular(8),
                                  underline: const SizedBox(),
                                  itemHeight: 48,
                                  isDense: true,
                                  value: promotionType,
                                  items: PromotionType.values
                                      .map((e) =>
                                          DropdownMenuItem<PromotionType>(
                                              value: e, child: Text(e.title)))
                                      .toList(),
                                  onChanged: (value) =>
                                      _onSelectPromotionType(value)),
                            ),
                            const TextFieldLabel("Discount amount",
                                isRequired: true),
                            MyTextField(
                              controller: _discountAmountController,
                              hintText: "Discount amount",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Discount amount is required";
                                }
                                if (double.tryParse(value) == null) {
                                  return "Not number type";
                                }
                                return null;
                              },
                            ),
                            const TextFieldLabel("Quantity"),
                            MyTextField(
                              controller: _quantityController,
                              hintText: "Quantity",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    int.tryParse(value) == null) {
                                  return "Not number type";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MyElevatedButton(
                                  onPressed: _onSubmit,
                                  widget: const Text("Submit")),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSelectPromotionType(PromotionType? promotionType) {
    if (promotionType == null) return;
    setState(() {
      this.promotionType = promotionType;
    });
  }

  Future<void> _onPickStartTime() async {
    DateTime? newDate = await Utils().showDateTimePicker(context);
    if (newDate != null) {
      setState(() {
        startTime = newDate;
        _startDateController.text = newDate.toFullDateTimeFormat();
      });
    }
  }

  Future<void> _onPickEndTime() async {
    DateTime? newDate = await Utils().showDateTimePicker(context);
    if (newDate != null) {
      setState(() {
        endTime = newDate;
        _endDateController.text = newDate.toFullDateTimeFormat();
      });
    }
  }

  void _initValues() {
    if (widget.promotion != null) {
      _codeController.text = widget.promotion!.code;
      _contentController.text = widget.promotion!.content;
      _startDateController.text =
          widget.promotion!.startTime.toFullDateTimeFormat();
      _endDateController.text =
          widget.promotion!.endTime.toFullDateTimeFormat();
      startTime = widget.promotion!.startTime;
      endTime = widget.promotion!.endTime;
      if (widget.promotion!.maximumDiscountValue != null) {
        _maxDiscountController.text =
            widget.promotion!.maximumDiscountValue.toString();
      }
      if (widget.promotion!.minimumOrderValue != null) {
        _minValueController.text =
            widget.promotion!.minimumOrderValue.toString();
      }
      _discountAmountController.text = widget.promotion!.amount.toString();
      _quantityController.text = widget.promotion!.quantity != null
          ? widget.promotion!.quantity.toString()
          : '';
    }
  }

  Future<void> _onPickImage() async {
    final Uint8List? image = await Utils().pickImage();
    setState(() {
      imageBytes = image;
    });
  }

  void _onSubmit() {
    if (key.currentState!.validate()) {
      if (widget.promotion == null) {
        _addPromotion();
      } else {
        _updatePromotion();
      }
    }
  }

  void _addPromotion() {
    context.read<PromotionsBloc>().add(AddPromotion(
          code: _codeController.text,
          content: _contentController.text,
          type: promotionType,
          imageBytes: imageBytes!,
          startTime: startTime!,
          endTime: endTime!,
          minimumOrderValue: _minValueController.text.isEmpty
              ? null
              : double.parse(_minValueController.text),
          maximumDiscountValue: _maxDiscountController.text.isEmpty
              ? null
              : double.parse(_maxDiscountController.text),
          discountAmount: double.parse(_discountAmountController.text),
          quantity: _quantityController.text.isEmpty
              ? null
              : int.parse(_quantityController.text),
        ));
  }

  void _updatePromotion() {
    context.read<PromotionsBloc>().add(UpdatePromotion(
          id: widget.promotion!.id,
          code: _codeController.text,
          content: _contentController.text,
          type: promotionType,
          imageBytes: imageBytes,
          currentImgUrl: widget.promotion!.imgUrl,
          startTime: startTime!,
          endTime: endTime!,
          minimumOrderValue: _minValueController.text.isEmpty
              ? null
              : double.parse(_minValueController.text),
          maximumDiscountValue: _maxDiscountController.text.isEmpty
              ? null
              : double.parse(_maxDiscountController.text),
          discountAmount: double.parse(_discountAmountController.text),
          quantity: _quantityController.text.isEmpty
              ? null
              : int.parse(_quantityController.text),
        ));
  }
}
