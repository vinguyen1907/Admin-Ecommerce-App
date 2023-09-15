import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';

class CategoryRepository {
  Future<List<Category>> fetchCategories() async {
    try {
      List<Category> categories = [AppConstants.allCategory];
      await categoriesRef
          .where('name', isNotEqualTo: 'New Arrivals')
          .get()
          .then((value) {
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
      return categories;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Category>> fetchCategoriesWithoutAll() async {
    try {
      List<Category> categories = [];
      await categoriesRef
          .where('name', isNotEqualTo: 'New Arrivals')
          .get()
          .then((value) {
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
      return categories;
    } catch (e) {
      throw Exception(e);
    }
  }
}
