import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

class RechargeSuccessScreen extends StatefulWidget {
  @override
  _RechargeSuccessState createState() => _RechargeSuccessState();
}

class _RechargeSuccessState extends State<RechargeSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      child: new Column(
         mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            new Container(
              width: 48.0,
              height: 48.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle, color: CanteenAppTheme.main),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            new Text("Nạp tiền thành công"),

          ]),
    ));
  }
}
