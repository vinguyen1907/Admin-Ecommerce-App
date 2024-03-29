import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final CollectionReference ordersRef =
    FirebaseFirestore.instance.collection('orders');
final CollectionReference productsRef =
    FirebaseFirestore.instance.collection('products');
final CollectionReference categoriesRef = firestore.collection("categories");
final CollectionReference chatRoomsRef = firestore.collection("chat_rooms");
final CollectionReference promotionsRef = firestore.collection("promotions");
final DocumentReference ordersStatisticsDocRef =
    firestore.collection("statistics").doc("orders_statistics");
final DocumentReference productsStatisticsDocRef =
    firestore.collection("statistics").doc("products_statistics");
final CollectionReference monthlySalesRef =
    ordersStatisticsDocRef.collection("monthly_sales");
final CollectionReference notificationsRef =
    firestore.collection("notifications");
