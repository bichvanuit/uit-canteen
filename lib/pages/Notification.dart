import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Notification.dart';
import 'package:uit_cantin/compoments/NotificationWidget.dart';

List<NotificationInfo> listNotification = <NotificationInfo>[
  new NotificationInfo(1, 'Title 1', 'Sub Title 1',
      'https://cdn.pixabay.com/photo/2015/12/16/17/41/bell-1096280_960_720.png'),
  new NotificationInfo(2, 'Title 1', 'Sub Title 2',
      'https://cdn.pixabay.com/photo/2015/12/16/17/41/bell-1096280_960_720.png'),
  new NotificationInfo(4, 'Title 1', 'Sub Title 4',
      'https://cdn.pixabay.com/photo/2015/12/16/17/41/bell-1096280_960_720.png'),
  new NotificationInfo(5, 'Title 1', 'Sub Title 5',
      'https://cdn.pixabay.com/photo/2015/12/16/17/41/bell-1096280_960_720.png'),
];

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Thông báo của bạn"),
        ),
        body: new Container(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
          child: new ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: listNotification.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return Container(
                    padding: EdgeInsets.only(right: 10, top: 20),
                    child: new NotificationWidget(
                      info: listNotification[position],
                    ));
              }),
        ));
  }
}
