import 'package:uit_cantin/config.dart';

class UserInfo {
  String email;
  String fullName;
  String avatar;

  UserInfo({
    this.email,
    this.fullName,
    this.avatar,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json["email"],
      fullName:  json["fullname"],
      avatar: ROOT_IMAGE + json["avatar"]
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["fullname"] = fullName;
    map["avatar"] = avatar;
    return map;
  }
}
