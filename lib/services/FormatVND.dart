import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatVND {


  static String getFormatPrice(String price) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: double.parse(price)
    );
    return fmf.output.withoutFractionDigits + ' VNĐ';
  }
}