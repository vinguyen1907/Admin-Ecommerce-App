import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toDateTimeFormat() {
    return DateFormat('dd/MM/yyyy hh:mm').format(this);
  }

  String toFullDateTimeFormat() {
    return DateFormat('EEE, MMM d, yyyy, h:mm a').format(this);
  }
}
