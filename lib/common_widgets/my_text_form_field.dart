import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.label,
      this.validator,
      this.maxLines,
      this.controller});
  final String hintText;
  final String label;
  final String? Function(String? value)? validator;
  final int? maxLines;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppStyles.headlineMedium,
          ),
          TextFormField(
              controller: controller,
              validator: validator,
              maxLines: maxLines,
              style:
                  AppStyles.titleSmall.copyWith(color: AppColors.primaryColor),
              decoration: InputDecoration(
                constraints: const BoxConstraints(
                  minHeight: 45,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
                hintText: hintText,
                hintStyle: AppStyles.titleSmall
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
      ),
    );
  }
}
