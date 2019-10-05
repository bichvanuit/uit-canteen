import 'package:uit_cantin/config.dart';

class Order{
  int foodId;
  int categoryId;
  int foodType;
  String foodName;
  String price;
  String discountPrice;
  String image;
  int amount;
  double star;

  Order(
    this.foodId,
    this.categoryId,
    this.foodType,
    this.foodName,
    this.price,
    this.discountPrice,
    this.image,
    this.amount,
    this.star
  );

  Order.fromJson(Map<String, dynamic> json) {
        this.foodId = json['food_id'];
        this.categoryId = json['category_id'];
        this.foodType = json['food_type'];
        this.foodName = json['food_name'];
        this.price = json['price'];
        this.discountPrice = json['discount_price'];
        this.image = json['image'] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json['image'];
        this.amount = json['amount'];
        this.star = json['star'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["category_id"] = categoryId;
    map["food_type"] = foodType;
    map['food_name'] = foodName;
    map['price'] = price;
    map['discount_price'] = discountPrice;
    map['image'] = image;
    map['amount'] = amount;
    return map;
  }
}