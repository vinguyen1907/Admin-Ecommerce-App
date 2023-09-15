import 'dart:developer';
import 'dart:typed_data';

import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/page_info.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      await productsRef
          .where('categoryId', isEqualTo: category.id)
          .get()
          .then((value) {
        products.addAll(value.docs
            .map((e) => Product.fromMap(e.data() as Map<String, dynamic>))
            .toList());
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

  Future<void> updateProduct({
    required Uint8List image,
    required String name,
    required Category category,
    required String brand,
    required double price,
    required String description,
    required String id,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('product_img');
      final task = await storageRef
          .child(
              '${category.name + DateTime.now().millisecondsSinceEpoch.toString()}.jpg')
          .putData(image);
      final linkImage = await task.ref.getDownloadURL();
      await productsRef.doc(id).update({
        'name': name,
        'brand': brand,
        'price': price,
        'categoryId': category.id,
        'description': description,
        'imgUrl': linkImage
      });
    } catch (e) {
      log("add product error: $e");
      throw Exception(e);
    }
  }

  Future<void> updateProduct1() async {
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
    await productsRef.doc(product.id).update({
      'soldCount': 0,
      'stockCount': 100,
    });
  }

  Future<PageInfo> getPageInfo(Category category, String query) async {
    List<Product> products = [];
    DocumentSnapshot? firstDocument;
    DocumentSnapshot? lastDocument;
    int? productsCount;
    if (query.isNotEmpty) {
      if (category.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef
            .where('keyword', arrayContains: query)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .orderBy('name')
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            firstDocument = value.docs.first;
            lastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        AggregateQuerySnapshot temp = await productsRef
            .where('categoryId', isEqualTo: category.id)
            .where('keyword', arrayContains: query)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .where('keyword', arrayContains: query)
            .orderBy('name')
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            firstDocument = value.docs.first;
            lastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    } else {
      if (category.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef.count().get();
        productsCount = temp.count;
        await productsRef
            .orderBy('name')
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        AggregateQuerySnapshot temp = await productsRef
            .where('categoryId', isEqualTo: category.id)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .orderBy('name')
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    }
    PageInfo pageInfo = PageInfo(
        productsCount: productsCount!,
        categorySelected: category,
        firstDocument: firstDocument,
        lastDocument: lastDocument,
        products: products);
    return pageInfo;
  }

  Future<PageInfo> loadNextPage(Category categorySelected, String query,
      DocumentSnapshot lastDocument) async {
    List<Product> products = [];
    DocumentSnapshot? newFirstDocument;
    DocumentSnapshot? newLastDocument;
    int? productsCount;
    if (query.isNotEmpty) {
      if (categorySelected.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef
            .where('keyword', arrayContains: query)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .orderBy('name')
            .startAfterDocument(lastDocument)
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            newFirstDocument = value.docs.first;
            newLastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        AggregateQuerySnapshot temp = await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .where('keyword', arrayContains: query)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .where('keyword', arrayContains: query)
            .orderBy('name')
            .startAfterDocument(lastDocument)
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            newFirstDocument = value.docs.first;
            newLastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    } else {
      if (categorySelected.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef.count().get();
        productsCount = temp.count;
        print(productsCount);
        await productsRef
            .orderBy('name')
            .startAfterDocument(lastDocument)
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            newFirstDocument = value.docs.first;
            newLastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        AggregateQuerySnapshot temp = await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .orderBy('name')
            .startAfterDocument(lastDocument)
            .limit(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            newFirstDocument = value.docs.first;
            newLastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    }
    PageInfo pageInfo = PageInfo(
        productsCount: productsCount!,
        categorySelected: categorySelected,
        firstDocument: newFirstDocument,
        lastDocument: newLastDocument,
        products: products);
    return pageInfo;
  }

  Future<PageInfo> loadPreviousPage(Category categorySelected, String query,
      DocumentSnapshot firstDocument) async {
    List<Product> products = [];
    DocumentSnapshot? newFirstDocument;
    DocumentSnapshot? newLastDocument;
    int? productsCount;
    if (query.isNotEmpty) {
      if (categorySelected.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef
            .where('keyword', arrayContains: query)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .orderBy('name')
            .endBeforeDocument(firstDocument)
            .limitToLast(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            newFirstDocument = value.docs.first;
            newLastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        AggregateQuerySnapshot temp = await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .where('keyword', arrayContains: query)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .where('keyword', arrayContains: query)
            .orderBy('name')
            .endBeforeDocument(firstDocument)
            .limitToLast(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            newFirstDocument = value.docs.first;
            newLastDocument = value.docs.last;
          }
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    } else {
      if (categorySelected.name == 'All') {
        AggregateQuerySnapshot temp = await productsRef.count().get();
        productsCount = temp.count;
        await productsRef
            .orderBy('name')
            .endBeforeDocument(firstDocument)
            .limitToLast(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          newFirstDocument = value.docs.first;
          newLastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      } else {
        AggregateQuerySnapshot temp = await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .orderBy('name')
            .endBeforeDocument(firstDocument)
            .limitToLast(AppConstants.numberItemsPerProductPage)
            .get()
            .then((value) {
          newFirstDocument = value.docs.first;
          newLastDocument = value.docs.last;
          products.addAll(value.docs
              .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
        });
      }
    }
    PageInfo pageInfo = PageInfo(
        productsCount: productsCount!,
        categorySelected: categorySelected,
        firstDocument: newFirstDocument,
        lastDocument: newLastDocument,
        products: products);
    return pageInfo;
  }
}
