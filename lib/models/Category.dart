import 'package:uit_cantin/config.dart';

class Category {
  int foodCategoryId;
  String foodCategoryName;
  String image;

  Category({
    this.foodCategoryId,
    this.foodCategoryName,
    this.image,
  });

  Category.fromJson(Map<String, dynamic> json) {
    this.foodCategoryId = json["food_category_id"];
    this.foodCategoryName = json["food_category_name"];
    this.image = ROOT_IMAGE + json["image"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_category_id"] = foodCategoryId;
    map["food_category_name"] = foodCategoryName;
    map["image"] = image;
    return map;
  }
}
