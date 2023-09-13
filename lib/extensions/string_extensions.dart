import 'package:admin_ecommerce_app/models/notification_type.dart';
import 'package:admin_ecommerce_app/models/order_status.dart';
import 'package:admin_ecommerce_app/models/promotion_type.dart';
import 'package:admin_ecommerce_app/models/user.dart';
import 'package:flutter/material.dart';

extension StringExtensions on String {
  Color toColor() {
    return Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
  }

  String formatName() {
    List<String> words = split(' ');
    if (words.length >= 2) {
      return words.sublist(words.length - 2).join(' ');
    } else {
      return this;
    }
  }

  // PromotionType toPromotion() {
  //   switch (this) {
  //     case "free_shipping":
  //       return PromotionType.freeShipping;
  //     case "percentage":
  //       return PromotionType.percentage;
  //     case "fixed_amount":
  //       return PromotionType.fixedAmount;
  //     default:
  //       return PromotionType.freeShipping;
  //   }
  // }

  // MessageType toMessageType() {
  //   switch (this) {
  //     case "text":
  //       return MessageType.text;
  //     case "image":
  //       return MessageType.image;
  //     case "voice":
  //       return MessageType.voice;
  //     default:
  //       return MessageType.text;
  //   }
  // }

  String maskCardNumber() {
    int start = 4;
    int end = length - 4;
    String firstFourDigits = substring(0, start);
    String lastFourDigits = substring(end, length);
    String maskedDigits = '*' * (end - start);

    return "$firstFourDigits$maskedDigits$lastFourDigits";
  }

  OrderStatus toOrderStatus() {
    return stringToOrderStatus[this] ?? OrderStatus.pending;
  }

  // Gender toGender() {
  //   return stringToGender[this] ?? Gender.notHave;
  // }

  // EWalletTransactionType toEWalletTransactionType() {
  //   return stringToEWalletTransactionType[this] ?? EWalletTransactionType.topUp;
  // }

  PromotionType toPromotion() {
    switch (this) {
      case "free_shipping":
        return PromotionType.freeShipping;
      case "percentage":
        return PromotionType.percentage;
      case "fixed_amount":
        return PromotionType.fixedAmount;
      default:
        return PromotionType.freeShipping;
    }
  }

  NotificationType toNotificationType() {
    switch (this) {
      case "promotion":
        return NotificationType.promotion;
      case "advertisement":
        return NotificationType.advertisement;
      case "statusOrder":
        return NotificationType.statusOrder;
      default:
        return NotificationType.promotion;
    }
  }

  UserType? toUserType() {
    switch (this) {
      case "admin":
        return UserType.admin;
      case "employee":
        return UserType.employee;
      default:
        return null;
    }
  }

  WorkingStatus toWorkingStatus() {
    switch (this) {
      case "working":
        return WorkingStatus.working;
      case "resigned":
        return WorkingStatus.resigned;
      case "retired":
        return WorkingStatus.retired;
      default:
        return WorkingStatus.working;
    }
  }
}
