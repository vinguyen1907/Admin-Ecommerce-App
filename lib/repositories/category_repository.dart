import 'dart:developer';

import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/models/category_page_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class CategoryRepository {
  Future<List<Category>> fetchCategories() async {
    try {
      List<Category> categories = [AppConstants.allCategory];
      await categoriesRef
          .where('name', isNotEqualTo: 'New Arrivals')
          .where('isDelete', isEqualTo: false)
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

  Future<void> addCategory(
      {required String name, required Uint8List image}) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('category_img');
      final task = await storageRef
          .child(
              '${name + DateTime.now().millisecondsSinceEpoch.toString()}.jpg')
          .putData(image);
      final linkImage = await task.ref.getDownloadURL();
      await categoriesRef.add({
        'name': name,
        'keyword': name.split(' '),
        'isDelete': false,
        'imgUrl': linkImage
      }).then((value) async {
        await categoriesRef.doc(value.id).update({'id': value.id});
      });
    } catch (e) {
      log("add category error: $e");
      throw Exception(e);
    }
  }

  Future<void> updateCategory(
      {required String name,
      required Uint8List image,
      required String id}) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('category_img');
      final task = await storageRef
          .child(
              '${name + DateTime.now().millisecondsSinceEpoch.toString()}.jpg')
          .putData(image);
      final linkImage = await task.ref.getDownloadURL();
      await categoriesRef.doc(id).update(
          {'name': name, 'keyword': name.split(' '), 'imgUrl': linkImage});
    } catch (e) {
      log("update category error: $e");
      throw Exception(e);
    }
  }

  Future<List<Category>> fetchCategoriesWithoutAll() async {
    try {
      List<Category> categories = [];
      await categoriesRef
          .where('name', isNotEqualTo: 'New Arrivals')
          .where('isDelete', isEqualTo: false)
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

  Future<CategoryPageInfo> getCategoryPageInfo(String query) async {
    List<Category> categories = [];
    DocumentSnapshot? firstDocument;
    DocumentSnapshot? lastDocument;
    int? categoriesCount;
    if (query.isNotEmpty) {
      AggregateQuerySnapshot temp = await categoriesRef
          .where('keyword', arrayContains: query)
          .where('name', isNotEqualTo: 'New Arrivals')
          .where('isDelete', isEqualTo: false)
          .count()
          .get();
      categoriesCount = temp.count;
      await categoriesRef
          .where('keyword', arrayContains: query)
          .where('isDelete', isEqualTo: false)
          .where('name', isNotEqualTo: 'New Arrivals')
          .orderBy('name')
          .limit(AppConstants.numberItemsPerProductPage)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          firstDocument = value.docs.first;
          lastDocument = value.docs.last;
        }
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
    } else {
      AggregateQuerySnapshot temp =
          await categoriesRef.where('isDelete', isEqualTo: false).count().get();
      categoriesCount = temp.count;
      await categoriesRef
          .where('isDelete', isEqualTo: false)
          .where('name', isNotEqualTo: 'New Arrivals')
          .orderBy('name')
          .limit(AppConstants.numberItemsPerProductPage)
          .get()
          .then((value) {
        firstDocument = value.docs.first;
        lastDocument = value.docs.last;
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
    }
    CategoryPageInfo categoryPageInfo = CategoryPageInfo(
      categoriesCount: categoriesCount,
      categories: categories,
      firstDocument: firstDocument,
      lastDocument: lastDocument,
    );
    return categoryPageInfo;
  }

  Future<CategoryPageInfo> loadNextPage(
      String query, DocumentSnapshot lastDocument) async {
    List<Category> categories = [];
    DocumentSnapshot? newFirstDocument;
    DocumentSnapshot? newLastDocument;
    int? categoriesCount;
    if (query.isNotEmpty) {
      AggregateQuerySnapshot temp = await categoriesRef
          .where('keyword', arrayContains: query)
          .where('isDelete', isEqualTo: false)
          .count()
          .get();
      categoriesCount = temp.count;
      await categoriesRef
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
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
    } else {
      AggregateQuerySnapshot temp =
          await productsRef.where('isDelete', isEqualTo: false).count().get();
      categoriesCount = temp.count;
      await categoriesRef
          .where('isDelete', isEqualTo: false)
          .orderBy('name')
          .startAfterDocument(lastDocument)
          .limit(AppConstants.numberItemsPerProductPage)
          .get()
          .then((value) {
        newFirstDocument = value.docs.first;
        newLastDocument = value.docs.last;
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
    }
    CategoryPageInfo categoryPageInfo = CategoryPageInfo(
      categoriesCount: categoriesCount,
      categories: categories,
      firstDocument: newFirstDocument,
      lastDocument: newLastDocument,
    );
    return categoryPageInfo;
  }

  Future<CategoryPageInfo> loadPreviousPage(
      String query, DocumentSnapshot firstDocument) async {
    List<Category> categories = [];
    DocumentSnapshot? newFirstDocument;
    DocumentSnapshot? newLastDocument;
    int? categoriesCount;
    if (query.isNotEmpty) {
      AggregateQuerySnapshot temp = await categoriesRef
          .where('keyword', arrayContains: query)
          .where('isDelete', isEqualTo: false)
          .count()
          .get();
      categoriesCount = temp.count;
      await categoriesRef
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
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
    } else {
      AggregateQuerySnapshot temp =
          await productsRef.where('isDelete', isEqualTo: false).count().get();
      categoriesCount = temp.count;
      await categoriesRef
          .where('isDelete', isEqualTo: false)
          .orderBy('name')
          .endBeforeDocument(firstDocument)
          .limitToLast(AppConstants.numberItemsPerProductPage)
          .get()
          .then((value) {
        newFirstDocument = value.docs.first;
        newLastDocument = value.docs.last;
        categories.addAll(value.docs
            .map((e) => Category.fromJson(e.data() as Map<String, dynamic>)));
      });
    }
    CategoryPageInfo categoryPageInfo = CategoryPageInfo(
      categoriesCount: categoriesCount,
      categories: categories,
      firstDocument: newFirstDocument,
      lastDocument: newLastDocument,
    );
    return categoryPageInfo;
  }

  Future<void> deleteCategory(String id) async {
    await categoriesRef.doc(id).update({'isDelete': true});
  }
}
