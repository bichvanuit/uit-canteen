import 'package:uit_cantin/config.dart';

class UserInfo {
  int userId;
  String email;
  int userGroupId;
  String fullName;
  String avatar;
  String username;
  String phone;
  bool newDevice;

  UserInfo({
    this.userId,
    this.email,
    this.userGroupId,
    this.fullName,
    this.avatar,
    this.username,
    this.phone,
    this.newDevice
  });

//  factory UserInfo.fromJson(Map<String, dynamic> json) {
//    return UserInfo(
//      email: json["email"],
//      userGroupId: json["user_group_id"],
//      fullName:  json["fullname"],
//      avatar: ROOT_IMAGE + json["avatar"]
//    );
//  }

  UserInfo.fromJson(Map<String, dynamic> json) {
    this.userId = json["user_id"];
    this.email =  json["email"];
    this.userGroupId =  json["user_group_id"];
    this.fullName =  json["fullname"];
    this.avatar =  json["avatar"] != null ? ROOT_IMAGE + json["avatar"] : "";
    this.username = json["username"];
    this.phone = json["phone"];
    this.newDevice = json["is_new_device"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["email"] = email;
    map["user_group_id"] = userGroupId;
    map["fullname"] = fullName;
    map["avatar"] = avatar;
    map["username"] = username;
    map["phone"] = phone;
    map["is_new_device"] = newDevice;
    return map;
  }
}
