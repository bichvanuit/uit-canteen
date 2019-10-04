import 'package:uit_cantin/config.dart';

class FoodInfo {
  int foodId;
  int categoryId;
  int foodType;
  String foodName;
  String price;
  String discountPrice;
  String image;
  double star;

  FoodInfo(
      {this.foodId,
      this.categoryId,
      this.foodType,
      this.foodName,
      this.price,
      this.discountPrice,
      this.image,
      this.star});

  FoodInfo.fromJson(Map<String, dynamic> json) {
    this.foodId = json["food_id"];
    this.categoryId = json["food_category_id"];
    this.foodType = json["food_type"];
    this.foodName = json["food_name"];
    this.price = json["price"];
    this.discountPrice = json["price_discount"];
    this.image = json["image"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["image"];
//    this.image = "https://img-global.cpcdn.com/005_recipes/5a67e00d7af9225a/1200x630cq70/photo.jpg";
    this.star = json["star"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["food_category_id"] = categoryId;
    map["food_type"] = foodType;
    map["food_name"] = foodName;
    map["price"] = price;
    map["price_discount"] = discountPrice;
    map["image"] = image;
    map["star"] = star;
    return map;
  }
}