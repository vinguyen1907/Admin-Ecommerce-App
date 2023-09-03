import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';

class CategoryRepository {
  Future<List<Category>> fetchCategories() async {
    try {
      List<Category> categories = [];
      await categoriesRef.get().then((value) {
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
      return categories;
    } catch (e) {
      throw Exception(e);
    }
  }
}
