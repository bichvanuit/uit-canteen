import 'package:uit_cantin/models/FoodInfo.dart';

class FoodList{
  String nameType;
  List<FoodInfo> listFood;

  FoodList({this.nameType, this.listFood});

  FoodList.fromJson(Map<String, dynamic> json) {
    nameType = json['food_type_name'];
    if (json['list_food'] != null) {
      listFood = new List<FoodInfo>();
      json['list_food'].forEach((v) {
        listFood.add(new FoodInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_type_name'] = this.nameType;
    if (this.listFood != null) {
      data['list_food'] = this.listFood.map((v) => v.toMap()).toList();
    }
    return data;
  }
}