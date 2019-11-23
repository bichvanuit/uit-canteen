class WalletInfo {
  int walletId;
  int userId;
  String balance;
  String password;
  int isActive;
  String createdDate;
  String createdBy;
  String modifiedDate;
  String modifiedBy;

  WalletInfo({
    this.walletId,
    this.userId,
    this.balance,
    this.password,
    this.isActive,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy
  });

  WalletInfo.fromJson(Map<String, dynamic> json) {
    this.walletId = json["user_wallet_id"];
    this.userId= json["user_id"];
    this.balance = json["balance"];
    this.password = json["password"];
    this.isActive = json["is_active"];
    this.createdDate = json["created_date"];
    this.createdBy = json["created_by"];
    this.modifiedDate = json["modified_date"];
    this.modifiedBy = json["modified_by"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user_wallet_id"] = walletId;
    map["user_id"] = userId;
    map["balance"] = balance;
    map["password"] = password;
    map["is_active"] = isActive;
    map["created_date"] = createdDate;
    map["created_by"] = createdBy;
    map["modified_date"] = modifiedDate;
    map["modified_by"] = modifiedBy;
    return map;
  }
}
