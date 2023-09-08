import 'package:admin_ecommerce_app/models/promotion_type.dart';

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
}
