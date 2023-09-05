import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class MyDropDownButton<T> extends StatelessWidget {
  const MyDropDownButton(
      {super.key, this.value, this.items, this.onChanged, required this.label});
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppStyles.headlineMedium,
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 45),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: AppColors.greyColor)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                iconSize: 20,
                isDense: true,
                value: value,
                icon: const Icon(Icons.arrow_drop_down_sharp),
                elevation: 10,
                style: const TextStyle(color: AppColors.primaryColor),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
