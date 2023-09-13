import 'package:admin_ecommerce_app/models/notification_type.dart';
import 'package:admin_ecommerce_app/models/promotion_type.dart';
import 'package:admin_ecommerce_app/models/user.dart';

extension StringExt on String {
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
