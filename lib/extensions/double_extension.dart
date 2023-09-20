extension DoubleExtensions on double {
  String toPriceString() {
    return "\$${toStringAsFixed(2)}";
  }

  String toFixedString(int numberOfDigitsAfterComma) {
    return "${toStringAsFixed(2)}%";
  }
}
