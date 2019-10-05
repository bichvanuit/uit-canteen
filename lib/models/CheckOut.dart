class CheckOut {
  int methodId;
  int deliveryPlaceId;
  String deliveryValue;

  CheckOut({
    this.methodId,
    this.deliveryPlaceId,
    this.deliveryValue,
  });

  CheckOut.fromJson(Map<String, dynamic> json) {
    this.methodId = json["payment_method_id"];
    this.deliveryPlaceId = json["delivery_place_type_id"];
    this.deliveryValue = json["delivery_place_value"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["payment_method_id"] = methodId;
    map["delivery_place_type_id"] = deliveryPlaceId;
    map["delivery_place_value"] = deliveryValue;
    return map;
  }
}
