class NotificationInfo{
  int notificationId;
  String title;
  String subTitle;
  String image;

  NotificationInfo(
      this.notificationId,
      this.title,
      this.subTitle,
      this.image
      );

  NotificationInfo.fromJson(Map<String, dynamic> json) {
    this.notificationId = json["notification_id"];
    this.title = json["title"];
    this.subTitle = json["subtitle"];
    this.image = json["image"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["notification_id"] = notificationId;
    map["title"] = title;
    map["subtitle"] = subTitle;
    map["image"] = image;
    return map;
  }
}