import 'package:intl/intl.dart';

String showTimeInFormattedFunction (DateTime time){
  return DateFormat('MMM d, y – h:mm a').format(time);
}