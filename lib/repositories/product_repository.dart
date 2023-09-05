import 'dart:developer';
import 'dart:typed_data';

import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> addProduct(
      {required String name,
      required String brand,
      required double price,
      required String description,
      required Category category,
      required Uint8List image}) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('product_img');
      final task = await storageRef
          .child(
              '${category.name + DateTime.now().millisecondsSinceEpoch.toString()}.jpg')
          .putData(image);
      final linkImage = await task.ref.getDownloadURL();
      await productsRef.add({
        'name': name,
        'brand': brand,
        'price': price,
        'categoryId': category.id,
        'createdAt': DateTime.now(),
        'description': description,
        'averageRating': 0,
        'reviewCount': 0,
        'imgUrl': linkImage
      }).then((value) async {
        await productsRef.doc(value.id).update({'id': value.id});
      });
    } catch (e) {
      log("add product error: $e");
      throw Exception(e);
    }
  }

  Future<void> updateProduct() async {
    List<Product> products = [];
    await productsRef.get().then((value) {
      products.addAll(value.docs
          .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
    });
    for (var i in products) {
      await addKeyWord(i);
    }
  }

  Future<void> addKeyWord(Product product) async {
    await productsRef
        .doc(product.id)
        .update({'keyword': product.name.toLowerCase().split(' ')});
  }
}
