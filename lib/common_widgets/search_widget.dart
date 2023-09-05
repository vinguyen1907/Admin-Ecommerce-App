import 'package:admin_ecommerce_app/common_widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.onQuery,
    required this.onClear,
  });

  final TextEditingController controller;
  final Function()? onQuery;
  final Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: MyTextField(
        controller: controller,
        hintText: 'Search',
        onSubmitted: (_) {
          if (onQuery != null) {
            onQuery!();
          }
        },
        suffixIcon: IconButton(
          onPressed: controller.text.isEmpty ? onQuery : onClear,
          icon: controller.text.isEmpty
              ? const Icon(Icons.search)
              : const Icon(Icons.clear),
        ),
      ),
    );
  }
}
