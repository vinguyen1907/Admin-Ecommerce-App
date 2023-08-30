import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final CollectionReference ordersRef =
    FirebaseFirestore.instance.collection('orders');
final CollectionReference productsRef =
    FirebaseFirestore.instance.collection('products');
