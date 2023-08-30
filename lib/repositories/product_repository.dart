import 'package:admin_ecommerce_app/constants/firebase_constants.dart';

class ProductRepository {
  Future<int> getProductsCount() async {
    try {
      final snapshot = await productsRef.count().get();
      return snapshot.count;
    } catch (e) {
      throw Exception(e);
    }
  }
}
