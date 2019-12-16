class Transaction {
  String bankName;
  String amount;
  int transactionTypeId;
  String transactionTypeName;

  Transaction({
    this.bankName,
    this.amount,
    this.transactionTypeId,
    this.transactionTypeName
  });
  Transaction.fromJson(Map<String, dynamic> json) {
    this.bankName = json["bank_name"];
    this.amount = json["amount"];
    this.transactionTypeId = json["transaction_type_id"];
    this.transactionTypeName = json["transaction_type_name"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["bank_name"] = bankName;
    map["amount"] = amount;
    map["transaction_type_id"] = transactionTypeId;
    map["transaction_type_name"] = transactionTypeName;
    return map;
  }
}
