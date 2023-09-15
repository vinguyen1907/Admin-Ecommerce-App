import 'package:admin_ecommerce_app/models/user.dart';

extension WorkingStatusExtension on WorkingStatus {
  String get title {
    switch (this) {
      case WorkingStatus.working:
        return "Working";
      case WorkingStatus.resigned:
        return "Resigned";
      case WorkingStatus.retired:
        return "Retired";
      default:
        return "";
    }
  }
}
