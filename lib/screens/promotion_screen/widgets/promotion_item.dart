import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/promotion.dart';
import 'package:admin_ecommerce_app/models/promotion_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromotionItem extends StatelessWidget {
  const PromotionItem({
    super.key,
    required this.promotion,
    required this.height,
    required this.width,
    required this.onGetPromotion,
  });
  final Promotion promotion;
  final double height;
  final double width;
  final VoidCallback onGetPromotion;

  @override
  Widget build(BuildContext context) {
    final String name = switch (promotion.type) {
      PromotionType.freeShipping => "Free Shipping",
      PromotionType.percentage =>
        "${(promotion as PercentagePromotion).percentage}% Off",
      PromotionType.fixedAmount =>
        "${(promotion as FixedAmountPromotion).amount}\$ Off",
    };

    // Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        CachedNetworkImage(
          imageUrl: promotion.imgUrl,
          imageBuilder: (context, imageProvider) => Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ), // Shimmer loading placeholder
          errorWidget: (context, url, error) =>
              const Icon(Icons.error), // Error widget
        ),
        Container(
          width: width,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppStyles.displayLarge,
              ),
              Text(
                promotion.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.headlineLarge
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "With code: ${promotion.code}",
                  style: AppStyles.displayMedium.copyWith(fontSize: 12),
                ),
              ),
              // MyInkWell(
              //   onTap: onGetPromotion,
              //   width: size.width * 0.1,
              //   height: size.height * 0.04,
              //   child: const Text(
              //     "Get now",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600, color: Colors.white),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
