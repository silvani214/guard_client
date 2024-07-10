import 'package:intl/intl.dart';

class Utils {
  static String formatDateToString(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
