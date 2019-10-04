class User{
  String username;
  String password;
  String token;

  User({
    this.username,
    this.password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        password: json['password']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}