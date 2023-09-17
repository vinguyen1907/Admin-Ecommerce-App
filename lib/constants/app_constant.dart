import 'package:admin_ecommerce_app/models/category.dart';

class AppConstants {
  static const int numberItemsPerPage = 5;
  static const int numberItemsPerProductPage = 10;
  static const Category allCategory = Category(id: '', name: 'All', imgUrl: '');
  static const String serverFirebaseKey =
      'AAAAbB4g87w:APA91bH_vUKqunFJJG53um7k7V2tMEnjZ6v1Mil7HzbxG9Z69lqybQTpEiQwMxRGt3WAJp5sh4Qx4DbftUxg0hbouetx05saUe18Hhhc1ShSeaLGvonNGXOmVWLt3wabIS08Wurse6ED';
  static const String adminId = 'admin';
  static const String fcmPostUrl = "https://fcm.googleapis.com/fcm/send";
  static const String fcmApiKey =
      "AAAAbB4g87w:APA91bH_vUKqunFJJG53um7k7V2tMEnjZ6v1Mil7HzbxG9Z69lqybQTpEiQwMxRGt3WAJp5sh4Qx4DbftUxg0hbouetx05saUe18Hhhc1ShSeaLGvonNGXOmVWLt3wabIS08Wurse6ED";
  static const int appIDCallService = 873318300;
  static const String appSignCallService =
      '5cdfa7af1e9db08e0a2b4e581c5bb600983aa40f2b9fd87b0193dde445721ed8';
}
