import 'dart:typed_data';
import 'image_picker_service_mobile.dart'
    if (dart.library.io) 'image_picker_service_mobile.dart';

final ImagePickerService imagePickerService = ImagePickerServiceMobile();

abstract class ImagePickerService {
  Future<Uint8List?> pickImage();
}
