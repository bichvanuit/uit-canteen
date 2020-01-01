class User{
  String username;
  String password;
  String deviceId;
  String token;

  User({
    this.username,
    this.password,
    this.deviceId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        password: json['password'],
        deviceId: json['deviceId']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    map["device_id"] = deviceId;
    return map;
  }
}