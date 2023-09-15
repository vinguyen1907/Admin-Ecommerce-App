import 'package:admin_ecommerce_app/models/promotion_type.dart';

extension PromotionTypeExt on PromotionType {
  String toPromotionString() {
    switch (this) {
      case PromotionType.freeShipping:
        return "free_shipping";
      case PromotionType.percentage:
        return "percentage";
      case PromotionType.fixedAmount:
        return "fixed_amount";
      default:
        return "free_shipping";
    }
  }

  String get title => promotionTypeTitles[this] ?? "Free Shipping";
}
