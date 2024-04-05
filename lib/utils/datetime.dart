import 'package:intl/intl.dart';

parseDateTime(String dateTime) {
  DateFormat format = DateFormat('E, dd MMM yyyy HH:mm:ss zzz');
  
  if (DateTime.tryParse(dateTime) != null) {
    return DateTime.parse(dateTime);
  } else {
    try {
    return format.parse(dateTime);
  } catch (e) {
    print("Error parsing datetime: $e");
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
  }
}