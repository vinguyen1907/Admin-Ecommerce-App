import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toDateTimeFormat() {
    return DateFormat('dd/MM/yyyy hh:mm').format(this);
  }

  String toFullDateTimeFormat() {
    return DateFormat('E, MMM d, y, h:mm a').format(this);
  }

  String formattedDateChat() {
    final now = DateTime.now();
    if (year == now.year) {
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      if (day == now.day) {
        final formatter = DateFormat('h:mm a');
        return formatter.format(this);
      } else if (day == yesterday.day) {
        final formatter = DateFormat('h:mm a');
        return 'Yesterday, ${formatter.format(this)}';
      } else {
        final formatter = DateFormat('dd MMM, h:mm a');
        return formatter.format(this);
      }
    } else {
      final formatter = DateFormat('dd MMM yyyy, h:mm a');
      return formatter.format(this);
    }
  }
}
