class BankLinked {
  int cardId;
  String cardNumber;
  int cardType;
  String bankName;

  BankLinked({
    this.cardId,
    this.cardNumber,
    this.cardType,
    this.bankName
  });

  BankLinked.fromJson(Map<String, dynamic> json) {
    this.cardId = json["card_id"];
    this.cardNumber = json["card_number"];
    this.cardType = json["card_type_id"];
    this.bankName = json["bank_name"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["card_id"] = cardId;
    map["card_number"] = cardNumber;
    map["card_type_id"] = cardType;
    map["bank_name"] = bankName;
    return map;
  }
}
