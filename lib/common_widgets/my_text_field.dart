import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
  });

  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: readOnly,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        initialValue: initialValue,
        keyboardType: keyboardType,
        controller: controller,
        style: AppStyles.titleSmall,
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: 40,
          ),
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
          hintStyle: AppStyles.primaryHintText,
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
        ));
  }
}
