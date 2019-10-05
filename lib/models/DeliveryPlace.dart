
class DeliveryPlace {
  int placeId;
  String placeName;

  DeliveryPlace({
    this.placeId,
    this.placeName,
  });

  DeliveryPlace.fromJson(Map<String, dynamic> json) {
    this.placeId = json["delivery_place_type_id"];
    this.placeName = json["delivery_place_type_name"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["delivery_place_type_id"] = placeId;
    map["delivery_place_type_name"] = placeName;
    return map;
  }
}
