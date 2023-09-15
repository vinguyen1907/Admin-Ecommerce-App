import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
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
        child: CustomLoadingWidget(),
      ),
    );
  Future<Uint8List?> pickImage() async {
    Uint8List? bytes;
    if (kIsWeb) {
      // Use image_picker_web for web.
      html.File? imageFile = await ImagePickerWeb.getImageAsFile();
      if (imageFile != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(imageFile);
        await reader.onLoad.first;
        final encoded = reader.result as String;
        // Remove the data:image/png;base64, part
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
        bytes = base64.decode(stripped);
      }
    } else {
      // Use image_picker for mobile.
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        bytes = await image.readAsBytes();
      }
    }
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
}
