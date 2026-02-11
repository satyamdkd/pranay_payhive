import 'package:intl/intl.dart';

String formatTransactionDate(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  DateTime now = DateTime.now();

  DateFormat timeFormat = DateFormat('HH:mm');
  DateFormat fullFormat = DateFormat('MMM dd HH:mm');

  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));
  DateTime targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (targetDay == today) {
    return "Today ${timeFormat.format(dateTime)}";
  } else if (targetDay == yesterday) {
    return "Yesterday ${timeFormat.format(dateTime)}";
  } else {
    return fullFormat.format(dateTime);
  }
}

/// Timestamp
// String formatNowUtcIso8601() {
//   final nowUtc = DateTime.now().toUtc();
//   final iso = nowUtc.toIso8601String(); /// e.g., 2025-08-17T03:39:12.650Z
//   return iso.replaceFirst('Z', '+00:00'); /// 2025-08-17T03:39:12.650+00:00
// }

String formatNowUtcIso8601() {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
}
