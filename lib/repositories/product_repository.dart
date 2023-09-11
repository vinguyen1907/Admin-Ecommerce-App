import 'dart:developer';

import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/product.dart';

class ProductRepository {
  Future<int> getProductsCount() async {
    try {
      final snapshot = await productsRef.count().get();
      return snapshot.count;
    } catch (e) {
      throw Exception(e);
    }
  }
  // Future<List<ProductDetail>> fetchProductDetails(Product product) async {
  //   try {
  //     List<ProductDetail> productDetails = [];
  //     await productsRef
  //         .doc(product.id)
  //         .collection('productDetails')
  //         .where('stock', isGreaterThan: 0)
  //         .get()
  //         .then((value) {
  //       productDetails
  //           .addAll(value.docs.map((e) => ProductDetail.fromJson(e.data())));
  //     });
  //     return productDetails;
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  Future<List<Product>> fetchProductInCategory(Category category) async {
    try {
      List<Product> products = [];
      if (category.name == 'New Arrivals') {
        await productsRef
            .orderBy('createdAt', descending: true)
            .limit(35)
            .get()
            .then((value) {
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>))
              .toList());
        });
      } else {
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .get()
            .then((value) {
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>))
              .toList());
        });
      }
      return products;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Product>> fetchNewArrivals() async {
    try {
      List<Product> products = [];
      await productsRef
          .orderBy("createdAt", descending: true)
          .limit(10)
          .get()
          .then((value) {
        products.addAll(value.docs
            .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
      });
      return products;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Product>> fetchPopular() async {
    try {
      List<Product> products = [];
      await productsRef
          .orderBy("reviewCount", descending: true)
          .limit(10)
          .get()
          .then((value) {
        products.addAll(value.docs
            .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
      });
      return products;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Product>> fetchAllProducts() async {
    try {
      List<Product> products = [];
      await productsRef.get().then((value) {
        products.addAll(value.docs
            .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
      });
      return products;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Product> fetchProductById(String id) async {
    try {
      final doc = await productsRef.doc(id).get();
      return Product.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      log("Fetch product error: $e");
      throw Exception(e);
    }
  }

  Future<List<Product>> fetchTopProducts() async {
    try {
      final snapshot = await productsRef
          .orderBy("soldCount", descending: true)
          .limit(5)
          .get();
      final List<Product> products = snapshot.docs
          .map((e) => Product.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return products;
    } catch (e) {
      throw Exception(e);
    }
  }
}
