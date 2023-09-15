import 'package:admin_ecommerce_app/utils/utils.dart';

class EditEmployeeFormValidators {
  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone is required";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!Utils.isEmailValid(value)) {
      return "Email is not valid";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  static String? addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Address is required";
    }
    return null;
  }

  static String? salaryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Salary is required";
    }
    if (double.tryParse(value) == null) {
      return "Salary must be a number";
    }
    return null;
  }
}
