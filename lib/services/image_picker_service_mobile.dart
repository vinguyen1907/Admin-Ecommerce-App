import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'image_picker_service.dart';

class ImagePickerServiceMobile implements ImagePickerService {
  @override
  Future<Uint8List?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await image.readAsBytes();
    }
    return null;
  }
}
