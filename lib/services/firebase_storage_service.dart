import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String> uploadImageInUint8ListType(
      String url, Uint8List image) async {
    final ref = FirebaseStorage.instance.ref().child(url);
    final uploadTask = ref.putData(image);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
