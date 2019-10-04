
class PaymentMethod{
  int methodId;
  String methodName;
  String logo;

  PaymentMethod(
      this.methodId,
      this.methodName,
      this.logo,
      );

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    this.methodId = json['payment_method_id'];
    this.methodName = json['payment_method_name'];
    this.logo = json['logo'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["payment_method_id"] = methodId;
    map["payment_method_name"] = methodName;
    map["logo"] = logo;
    return map;
  }
}