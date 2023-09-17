import 'package:admin_ecommerce_app/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/my_outlined_button.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/screens/edit_category_screen/edit_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});
  final Category category;
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
                    image: NetworkImage(category.imgUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.labelMedium,
          ),
          const SizedBox(
            height: 6,
          ),
          MyOutlinedButton(
              onPressed: () => _navigateEditCategoryScreen(context),
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
                _deleteCategory(context, category.id);
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

  _navigateEditCategoryScreen(BuildContext context) {
    Navigator.pushNamed(context, EditCategoryScreen.routeName,
        arguments: category);
  }

  _deleteCategory(BuildContext context, String id) {
    context.read<CategoryScreenBloc>().add(DeleteCategory(id: id));
  }
}
