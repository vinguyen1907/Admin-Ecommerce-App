import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/extensions/string_extension.dart';
import 'package:admin_ecommerce_app/models/user.dart';

class UserRepository {
  Future<UserModel?> getUser() async {
    try {
      final doc = await usersRef.doc(firebaseAuth.currentUser!.uid).get();
      if (doc.exists) {
        final type = (doc.data() as Map<String, dynamic>)['type']
            .toString()
            .toUserType();
        if (type == UserType.admin || type == UserType.employee) {
          final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          return user;
        } else {
          throw Exception("You not have permission to access this page");
        }
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      rethrow;
    }
  }
}
