import 'package:uit_cantin/config.dart';

class CardGet {
  int foodId;
  String foodName;
  String image;
  int isPublished;
  String price;
  String discountPrice;
  String note;
  int amount;


  CardGet({
    this.foodId,
    this.foodName,
    this.image,
    this.isPublished,
    this.price,
    this.discountPrice,
    this.note,
    this.amount
  });

  CardGet.fromJson(Map<String, dynamic> json) {
    this.foodId = json["food_id"];
    this.foodName = json["food_name"];
    this.image = json["image"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["image"];
    this.isPublished = json["is_published"];
    this.price = json["price"];
    this.discountPrice = json["price_discount"];
    this.note = json["note"];
    this.amount = json["amount"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["food_name"] = foodName;
    map["image"] = image;
    map["is_published"] = isPublished;
    map["price"] = price;
    map["price_discount"] = discountPrice;
    map["note"] = note;
    map["amount"] = amount;
    return map;
  }
}
