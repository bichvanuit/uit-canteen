import 'package:uit_cantin/config.dart';
class BankLinked {
  int cardId;
  String cardNumber;
  int cardType;
  String logo;
  String bankName;

  BankLinked({
    this.cardId,
    this.cardNumber,
    this.cardType,
    this.logo,
    this.bankName
  });

  BankLinked.fromJson(Map<String, dynamic> json) {
    this.cardId = json["card_id"];
    this.cardNumber = json["card_number"];
    this.cardType = json["card_type_id"];
    this.logo = json["logo"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["logo"];
    this.bankName = json["bank_name"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["card_id"] = cardId;
    map["card_number"] = cardNumber;
    map["card_type_id"] = cardType;
    map["logo"] = logo;
    map["bank_name"] = bankName;
    return map;
  }
}
