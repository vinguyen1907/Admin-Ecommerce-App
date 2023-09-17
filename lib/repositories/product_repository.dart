import 'dart:developer';
import 'dart:typed_data';

import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/extensions/color_extensions.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/page_info.dart';
import 'package:admin_ecommerce_app/models/product.dart';
import 'package:admin_ecommerce_app/models/product_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
          .where('isDelete', isEqualTo: false)
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
        'keyword': name.split(' '),
        'categoryId': category.id,
        'createdAt': DateTime.now(),
        'description': description,
        'isDelete': false,
        'averageRating': 0,
        'reviewCount': 0,
        'stockCount': 0,
        'soldCount': 0,
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
        'keyword': name.toLowerCase().split(' '),
        'categoryId': category.id,
        'description': description,
        'imgUrl': linkImage
      });
    } catch (e) {
      log("add product error: $e");
      throw Exception(e);
    }
  }

  Future<void> deleteProduct(String id) async {
    await productsRef.doc(id).update({'isDelete': true});
  }

  Future<void> updateProduct1() async {
    List<Product> products = [];
    await productsRef.get().then((value) async {
      products.addAll(value.docs
          .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
      // value.docs.forEach((element) {
      //   productsRef
      //       .doc(element.id)
      //       .collection('productDetails')
      //       .get()
      //       .then((value) {
      //     if (value.docs.isEmpty) {
      //       productsRef.doc(element.id).delete();
      //     }
      //   });
      // });
    });
    for (var i in products) {
      await addKeyWord(i);
    }
  }

  Future<void> addKeyWord(Product product) async {
    await productsRef.doc(product.id).update({
      'isDelete': false,
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .where('keyword', arrayContains: query)
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: category.id)
            .where('isDelete', isEqualTo: false)
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
        productsCount: productsCount,
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .where('keyword', arrayContains: query)
            .where('isDelete', isEqualTo: false)
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
        await productsRef
            .orderBy('name')
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
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
        productsCount: productsCount,
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('keyword', arrayContains: query)
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
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
            .where('isDelete', isEqualTo: false)
            .count()
            .get();
        productsCount = temp.count;
        await productsRef
            .where('categoryId', isEqualTo: categorySelected.id)
            .where('isDelete', isEqualTo: false)
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
        productsCount: productsCount,
        categorySelected: categorySelected,
        firstDocument: newFirstDocument,
        lastDocument: newLastDocument,
        products: products);
    return pageInfo;
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

  Future<void> addProductDetail(
      {required String productId,
      required String size,
      required Color color}) async {
    await productsRef
        .doc(productId)
        .collection('productDetails')
        .add({'size': size, 'color': color.toColorCode(), 'stock': 0});
  }

  Future<List<ProductDetail>> getProductDetails(
      {required String productId}) async {
    List<ProductDetail> productDetails = [];
    await productsRef
        .doc(productId)
        .collection('productDetails')
        .get()
        .then((value) {
      productDetails
          .addAll(value.docs.map((e) => ProductDetail.fromJson(e.data())));
    });
    return productDetails;
  }

  Future<void> importProductDetail(
      {required ProductDetail productDetail,
      required Product product,
      required int quantity}) async {
    await productsRef
        .doc(product.id)
        .collection('productDetails')
        .where('size', isEqualTo: productDetail.size)
        .where('color', isEqualTo: productDetail.color)
        .get()
        .then((value) async {
      await productsRef
          .doc(product.id)
          .collection('productDetails')
          .doc(value.docs.first.id)
          .update({'stock': productDetail.stock + quantity});
    });
  }
}
