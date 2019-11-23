import 'package:uit_cantin/config.dart';

class BankInfo {
  int bankId;
  String bankName;
  String logo;
  String createDate;
  String createBy;
  String modifiedDate;
  String modifiedBy;

  BankInfo({
    this.bankId,
    this.bankName,
    this.logo,
    this.createDate,
    this.createBy,
    this.modifiedDate,
    this.modifiedBy
  });

  BankInfo.fromJson(Map<String, dynamic> json) {
    this.bankId = json["bank_id"];
    this.bankName= json["bank_name"];
    this.logo = json["logo"] == null ? IMAGE_DEFAULT : ROOT_IMAGE + json["logo"];
    this.createDate = json["created_date"];
    this.createBy = json["created_by"];
    this.modifiedDate = json["modified_date"];
    this.modifiedBy = json["modified_by"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["bank_id"] = bankId;
    map["bank_name"] = bankName;
    map["logo"] = logo;
    map["created_date"] = createDate;
    map["created_by"] = createBy;
    map["modified_date"] = modifiedDate;
    map["modified_by"] = modifiedBy;
    return map;
  }
}
