import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toColorCode() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }
}
