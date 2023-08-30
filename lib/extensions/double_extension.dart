extension DoubleExtensions on double {
  String toPriceString() {
    return "\$${toStringAsFixed(2)}";
  }
}
