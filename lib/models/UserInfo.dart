import 'package:uit_cantin/config.dart';

class UserInfo {
  int userId;
  String email;
  int userGroupId;
  String fullName;
  String avatar;
  String username;

  UserInfo({
    this.userId,
    this.email,
    this.userGroupId,
    this.fullName,
    this.avatar,
    this.username
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
    this.avatar =  ROOT_IMAGE + json["avatar"];
    this.username = json["username"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["email"] = email;
    map["user_group_id"] = userGroupId;
    map["fullname"] = fullName;
    map["avatar"] = avatar;
    map["username"] = username;
    return map;
  }
}
