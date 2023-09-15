import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerUtils {
  static Future<Uint8List?> openFilePicker(BuildContext context) async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final Uint8List temp = await image!.readAsBytes();
      return temp;
    } catch (e) {
      if (!kIsWeb) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          if (!context.mounted) return null;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Storage Access Required'),
                content: const Text(
                    'To use storage features, please grant storage access.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: AppStyles.labelMedium,
                      )),
                  TextButton(
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: const Text(
                        'Open settings',
                        style: AppStyles.labelMedium,
                      )),
                ],
              );
            },
          );
        }
      }
    }
    return null;
  }
}
