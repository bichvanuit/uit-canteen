import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  _OrderSuccess createState() => _OrderSuccess();
}

class _OrderSuccess extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            padding: new EdgeInsets.all(25.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 200.0,
                  width: 200.0,
                  child: new Image.asset('assets/order-success.png'),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      "Đặt món thành công",
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
                      "Xin bạn chờ trong giây lát",
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
