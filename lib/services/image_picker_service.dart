import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'image_picker_service_mobile.dart'
    if (dart.library.io) 'image_picker_service_mobile.dart';
import 'image_picker_service_web.dart'
    if (dart.library.html) 'image_picker_service_web.dart';

final ImagePickerService imagePickerService =
    kIsWeb ? ImagePickerServiceWeb() : ImagePickerServiceMobile();

abstract class ImagePickerService {
  Future<Uint8List?> pickImage();
}
