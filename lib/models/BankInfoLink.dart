class BankInfoLink {
  String cardholderName;
  String cardNumber;
  String bankId;
  String cardTypeId;
  String validFrom;

  BankInfoLink({
    this.cardholderName,
    this.cardNumber,
    this.bankId,
    this.cardTypeId,
    this.validFrom
  });

  BankInfoLink.fromJson(Map<String, dynamic> json) {
    this.cardholderName = json["cardholder_name"];
    this.cardNumber= json["card_number"];
    this.bankId = json["bank_id"];
    this.cardTypeId = json["card_type_id"];
    this.validFrom = json["valid_from"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["cardholder_name"] = cardholderName;
    map["card_number"] = cardNumber;
    map["bank_id"] = bankId;
    map["card_type_id"] = cardTypeId;
    map["valid_from"] = validFrom;
    return map;
  }
}
