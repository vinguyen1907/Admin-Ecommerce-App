import 'package:admin_ecommerce_app/blocs/product_screen_bloc/product_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_outlined_button.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/screens/edit_product_screen/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyColor, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(product.imgUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.labelMedium,
          ),
          Text(
            product.price.toPriceString(),
            style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(
            height: 6,
          ),
          MyOutlinedButton(
              onPressed: () => _navigateEditProductScreen(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  Text(
                    'Edit',
                    style: AppStyles.bodySmall
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              )),
          const SizedBox(
            height: 6,
          ),
          MyOutlinedButton(
              onPressed: () {
                _deleteProduct(context, product.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                  Text(
                    'Delete',
                    style:
                        AppStyles.bodySmall.copyWith(color: Colors.redAccent),
                  ),
                ],
              )),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  _navigateEditProductScreen(BuildContext context) {
    Navigator.pushNamed(context, EditProductScreen.routeName,
        arguments: product);
  }

  _deleteProduct(BuildContext context, String id) {
    context.read<ProductScreenBloc>().add(DeleteProduct(id: id));
  }
}
