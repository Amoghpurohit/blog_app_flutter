
import 'package:intl/intl.dart';

String formatDateTodMMMYYYY(DateTime dateTime){
  return DateFormat('d MMM, yyyy').format(dateTime);
}