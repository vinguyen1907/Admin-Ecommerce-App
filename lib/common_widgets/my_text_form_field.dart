import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.label,
      this.validator,
      this.maxLines});
  final String hintText;
  final String label;
  final String? Function(String? value)? validator;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.headlineMedium,
        ),
        TextFormField(
            validator: validator,
            maxLines: maxLines,
            style:
                AppStyles.labelMedium.copyWith(color: AppColors.primaryColor),
            decoration: InputDecoration(
              constraints: const BoxConstraints(
                minHeight: 40,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              hintStyle: AppStyles.labelMedium
                  .copyWith(color: AppColors.greyTextColor),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.greyColor)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.greyColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
            ))
      ],
    );
  }
}
