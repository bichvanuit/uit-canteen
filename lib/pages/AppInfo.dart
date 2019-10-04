import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppInfoScreen extends StatefulWidget {
  @override
  _AppInfo createState() => _AppInfo();
}

class _AppInfo extends State<AppInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Thông tin app"),
        ),
        body: new Container(
            padding: new EdgeInsets.all(25.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 200.0,
                  width: 200.0,
                  child: new Image.asset('assets/online-menu.png'),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      "App đặt món ăn tại Căn tin UIT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      "Được phát triển bởi V.....",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            )));
  }
}
