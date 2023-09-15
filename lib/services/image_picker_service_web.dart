import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';
import 'image_picker_service.dart';
import "package:universal_html/html.dart" as html;

class ImagePickerServiceWeb implements ImagePickerService {
  @override
  Future<Uint8List?> pickImage() async {
    html.File? imageFile = await ImagePickerWeb.getImageAsFile();
    if (imageFile != null) {
      final reader = html.FileReader();
      reader.readAsDataUrl(imageFile);
      await reader.onLoad.first;
      final encoded = reader.result as String;
      final stripped =
          encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      return base64.decode(stripped);
    }
    return null;
  }
}
