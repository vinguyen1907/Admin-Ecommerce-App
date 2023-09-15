import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.image,
      this.onTap});
  final double height;
  final double width;
  final Uint8List? image;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: image != null
                ? DecorationImage(
                    image: MemoryImage(
                      image!,
                    ),
                    fit: BoxFit.cover)
                : null,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.greyColor),
        child: image == null
            ? const Center(
                child: Icon(
                  Icons.image,
                  color: AppColors.greyTextColor,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
