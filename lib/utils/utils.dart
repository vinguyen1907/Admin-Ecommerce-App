import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Utils {
  String getFullAddress(
      {required String street,
      required String state,
      required String city,
      required String country}) {
    return '$street, $city, $state, $country';
  }

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
}
