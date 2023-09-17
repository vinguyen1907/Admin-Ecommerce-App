import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/services/image_picker_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        elevation: 0,
        child: CustomLoadingWidget(),
      ),
    );
  }

  Future<Uint8List?> pickImage() async {
    Uint8List? bytes;
    bytes = await imagePickerService.pickImage();
    return bytes;
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    DateTime? newDate = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    return newDate;
  }

  static bool isEmailValid(String email) {
    final RegExp regex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }

  static Future<void> changeSignInState(bool isSignedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isSignedIn", isSignedIn);
  }

  static Future<bool> getSignInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isSignedIn = prefs.getBool("isSignedIn") ?? false;
    return isSignedIn;
  }

  static Future<DateTime?> showMyDatePicker(
      {required BuildContext context,
      DateTime? initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate);
    return date;
  }

  void showSuccessful(
      {required BuildContext context,
      required String title,
      required String desc,
      VoidCallback? btnOkOnPress}) {
    Size size = MediaQuery.of(context).size;
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      width: Responsive.isMobile(context) ? null : size.width * 0.35,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }
  void showFail(
      {required BuildContext context,
        required String title,
        required String desc,
        VoidCallback? btnCancelOnPress,
        VoidCallback? btnOkOnPress}){
    Size size = MediaQuery.of(context).size;
    AwesomeDialog(
      context: context,
      width: Responsive.isMobile(context) ? null : size.width * 0.35,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Image is empty',
      desc: 'Please select an image',
      btnCancelOnPress: btnCancelOnPress,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }
}
