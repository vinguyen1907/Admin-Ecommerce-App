import 'package:admin_ecommerce_app/common_widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.onQuery,
  });

  final TextEditingController controller;
  final Function()? onQuery;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: MyTextField(
        controller: controller,
        hintText: 'Search',
        suffixIcon: IconButton(
          onPressed: onQuery,
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
