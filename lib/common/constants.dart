import 'package:intl/intl.dart';

Map<String, String> defaultHeader = {
  'Content-Type': 'application/json; charset=UTF-8'
};

final rupiahFormatter =
    NumberFormat.currency(decimalDigits: 0, locale: "id_ID", symbol: "Rp");
