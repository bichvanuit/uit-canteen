import 'package:uit_cantin/config.dart';

class FoodType {
  int foodCategoryId;
  int foodTypeId;
  String foodTypeName;
  String image;
  int amount;
  int amountDiscount;

  FoodType({
    this.foodCategoryId,
    this.foodTypeId,
    this.foodTypeName,
    this.image,
    this.amount,
    this.amountDiscount
  });

  FoodType.fromJson(Map<String, dynamic> json) {
    this.foodCategoryId = json["food_category_id"];
    this.foodTypeId = json["food_type_id"];
    this.foodTypeName = json["food_type_name"];
    this.image = ROOT_IMAGE + json["image"];
    this.amount = json["amount"];
    this.amountDiscount = json["amount_discount"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_category_id"] = foodCategoryId;
    map["food_type_id"] = foodTypeId;
    map["food_type_name"] = foodTypeName;
    map["image"] = image;
    map["amount"] = amount;
    map["amount_discount"] = amountDiscount;
    return map;
  }
}
