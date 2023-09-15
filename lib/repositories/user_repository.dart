import 'dart:typed_data';

import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/extensions/string_extensions.dart';
import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/services/firebase_auth_service.dart';
import 'package:admin_ecommerce_app/services/firebase_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<List<Employee>> fetchEmployee() async {
    try {
      final snapshot =
          await usersRef.where("type", isEqualTo: UserType.employee.name).get();
      final employees = snapshot.docs
          .map((doc) => Employee.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return employees;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addEmployees(
      {required Employee employee,
      required Uint8List? image,
      required String password}) async {
    try {
      // Create account in firebase auth
      final userCredential = await FirebaseAuthService()
          .createEmployeeAccount(email: employee.email, password: password);
      // Upload employee profile
      String? imgUrl;
      if (image != null) {
        imgUrl = await FirebaseStorageService.uploadImageInUint8ListType(
            "admin_avatar/${userCredential.user!.uid}", image);
      }
      // Create user in firestore
      await usersRef.doc(userCredential.user!.uid).set(employee
          .copyWith(id: userCredential.user!.uid, imgUrl: imgUrl)
          .toMap());
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateEmployee(
      {required Employee employee,
      required Uint8List? image,
      required bool resetPassword}) async {
    try {
      // Create account in firebase auth
      if (resetPassword) {
        FirebaseAuthService().sendResetPasswordEmail(email: employee.email);
      }
      // Upload employee profile if image is changed
      String? imgUrl;
      if (image != null) {
        imgUrl = await FirebaseStorageService.uploadImageInUint8ListType(
            "admin_avatar/${employee.id}", image);
      }
      // Create user in firestore
      await usersRef
          .doc(employee.id)
          .update(employee.copyWith(imgUrl: imgUrl).toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteEmployee({required String id}) async {
    try {
      await usersRef.doc(id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
