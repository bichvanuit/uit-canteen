import 'package:uit_cantin/config.dart';

class History {
  int orderId;
  String createDate;
  List<FoodInfo> foodInfo;

  History({this.orderId, this.createDate, this.foodInfo});

  factory History.fromJson(Map<String, dynamic> json) {
    var list = json['food_info'] as List;
    List<FoodInfo> foodInfo = list.map((i) => FoodInfo.fromJson(i)).toList();

    return History(
        orderId: json["order_id"],
        createDate: json["created_date"],
        foodInfo: foodInfo
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["order_id"] = orderId;
    map["created_date"] = createDate;
    map["food_info"] = foodInfo;
    return map;
  }
}

class FoodInfo {
  int foodId;
  String foodName;
  String image;
  String price;
  String note;
  int quantity;

  FoodInfo(
      {this.foodId,
      this.foodName,
      this.image,
      this.price,
      this.note,
      this.quantity});

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
        foodId: json["food_id"],
        foodName: json["food_name"],
        image: json["image"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["image"],
        price: json["price"],
        note: json["price_discount"],
        quantity: json["quantity"],
    );

  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["food_id"] = foodId;
    map["food_name"] = foodName;
    map["image"] = image;
    map["price"] = price;
    map["note"] = note;
    map["quantity"] = quantity;
    return map;
  }
}
