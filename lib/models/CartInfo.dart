class CardInfo {
  String foodId;
  String note;
  String quantity;

  CardInfo({
    this.foodId,
    this.note,
    this.quantity,
  });

  CardInfo.fromJson(Map<String, dynamic> json) {
    this.foodId = json["food_id"];
    this.note = json["note"];
    this.quantity = json["quantity"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["note"] = note;
    map["quantity"] = quantity;
    return map;
  }
}
