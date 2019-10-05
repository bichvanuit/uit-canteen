import 'package:uit_cantin/config.dart';
class CategoryDetail{
  int categoryId;
  int foodType;
  String foodTypeName;
  String image;
  int amount;

  CategoryDetail(
      this.categoryId,
      this.foodType,
      this.foodTypeName,
      this.image,
      this.amount
      );

  CategoryDetail.fromJson(Map<String, dynamic> json) {
    this.categoryId = json["food_category_id"];
    this.foodType = json["food_type"];
    this.foodTypeName = json["food_type_name"];
    this.image = json["image"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["image"];
    this.amount = json["amount"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_category_id"] = categoryId;
    map["food_type"] = foodType;
    map["food_type_name"] = foodTypeName;
    map["image"] = image;
    map["amount"] = amount;
    return map;
  }
}