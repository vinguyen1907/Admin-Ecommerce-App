import 'package:admin_ecommerce_app/common_widgets/my_text_form_field.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class AddProductDialog extends StatelessWidget {
  const AddProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.defaultHorizontalContentPadding,
            vertical: 15),
        width: size.width * 0.4,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8)),
        child: const Form(
          child: Column(
            children: [
              MyTextFormField(
                hintText: 'Product name',
                label: 'Product name',
              ),
              MyTextFormField(
                hintText: 'Product brand',
                label: 'Product brand',
              ),
              MyTextFormField(
                hintText: 'Product description',
                label: 'Product description',
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
