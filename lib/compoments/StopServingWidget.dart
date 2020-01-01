import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

class StopServingWidget extends StatefulWidget {
  _StopServingWidget createState() => _StopServingWidget();
}

class _StopServingWidget extends State<StopServingWidget> {
  DateTime now = DateTime.now();
  bool isService = true;

  @override
  initState() {
    int hour = now.hour;
    if (hour < 7 || hour > 17) {
      isService = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isService ? new Container(
        width: MediaQuery.of(context).size.width,
        //    height: 50,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Color(0XFFEFDADA),
          border: Border.all(width: 0.5, color: CanteenAppTheme.main),
          borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
        ),
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.warning,
              color: CanteenAppTheme.main,
              size: 30,
            ),
            SizedBox(width: 15.0),
            new Text("Căn tin đã đóng cửa",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: CanteenAppTheme.main)),
          ],
        )) : new Container();
  }
}
