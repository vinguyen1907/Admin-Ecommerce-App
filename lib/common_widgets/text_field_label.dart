import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel(
    this.label, {
    super.key,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: RichText(
          text: TextSpan(
              text: label,
              style: AppStyles.primaryTextFieldLabel,
              children: [
            if (isRequired)
              TextSpan(
                text: " *",
                style:
                    AppStyles.primaryTextFieldLabel.copyWith(color: Colors.red),
              )
          ])),
    );
  }
}
