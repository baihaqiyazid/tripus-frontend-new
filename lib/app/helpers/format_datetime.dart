import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';

String formatTimeAgo(String datetimeString) {
  final parsedDatetime = DateTime.parse(datetimeString);
  final now = DateTime.now();

  final difference = now.difference(parsedDatetime);

  return timeago.format(now.subtract(difference), locale: 'en_short');
}

String formatDate(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);
  int day = dateTime.day;
  int month = dateTime.month;
  int year = dateTime.year;

  String monthName = DateFormat.MMMM('id_ID').format(dateTime);

  String formattedDate = '$day $monthName $year';

  return formattedDate;
}

String formatDateNum(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);
  int day = dateTime.day;
  int month = dateTime.month;
  int year = dateTime.year;

  String monthName = DateFormat.MMMM('id_ID').format(dateTime);

  String formattedDate = '$day/$month/$year';

  return formattedDate;
}

String generateRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}