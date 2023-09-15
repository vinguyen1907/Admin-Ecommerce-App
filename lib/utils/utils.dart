import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';

class Utils {
  String getFullAddress(
      {required String street,
      required String state,
      required String city,
      required String country}) {
    return '$street, $city, $state, $country';
  }

  void showDialogLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: CustomLoadingWidget(),
      ),
    );
  }
}
