class ValidatorUtils {
  static String? validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return 'Please enter a valid double';
    }
    return null;
  }

  static String? validateImport(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a quantity';
    }
    if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
      return 'Please enter a valid int';
    }
    return null;
  }
}
