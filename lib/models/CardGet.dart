import 'package:uit_cantin/config.dart';

class CardGet {
  int foodId;
  String foodName;
  String image;
  String amount;

  CardGet({
    this.foodId,
    this.foodName,
    this.image,
    this.amount
  });

  CardGet.fromJson(Map<String, dynamic> json) {
    this.foodId = json["food_id"];
    this.foodName = json["food_name"];
    this.image = ROOT_IMAGE + json["image"];
    this.amount = json["amount"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["food_name"] = foodName;
    map["image"] = image;
    map["amount"] = amount;
    return map;
  }
}
