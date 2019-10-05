import 'package:uit_cantin/config.dart';

class CardGet {
  int foodId;
  String foodName;
  String image;
  int amount;
  int isPublished;

  CardGet({
    this.foodId,
    this.foodName,
    this.image,
    this.amount,
    this.isPublished
  });

  CardGet.fromJson(Map<String, dynamic> json) {
    this.foodId = json["food_id"];
    this.foodName = json["food_name"];
    this.image = json["image"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["image"];
    this.amount = json["amount"];
    this.isPublished = json["is_published"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["food_name"] = foodName;
    map["image"] = image;
    map["amount"] = amount;
    map["is_published"] = isPublished;
    return map;
  }
}
