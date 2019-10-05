import 'package:uit_cantin/config.dart';

class UserInfo {
  String email;
  int userGroupId;
  String fullName;
  String avatar;

  UserInfo({
    this.email,
    this.userGroupId,
    this.fullName,
    this.avatar,
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
    this.email =  json["email"];
    this.userGroupId =  json["user_group_id"];
    this.fullName =  json["fullname"];
    this.avatar =  ROOT_IMAGE + json["avatar"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["user_group_id"] = userGroupId;
    map["fullname"] = fullName;
    map["avatar"] = avatar;
    return map;
  }
}
