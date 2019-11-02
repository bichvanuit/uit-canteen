import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

class AdvertisementWall extends StatefulWidget {
  _AdvertisementWall createState() => _AdvertisementWall();
}

class _AdvertisementWall extends State<AdvertisementWall> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          height: 120.0,
          decoration: BoxDecoration(color: CanteenAppTheme.main),
        ),
        new Container(
          margin: const EdgeInsets.only(top: 70.0, left: 20, right: 20),
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          height: 150.0,
          decoration: new BoxDecoration(
              color: CanteenAppTheme.white,
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: CanteenAppTheme.grey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 5.0),
              ]),
          child: new Row(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Text(
                    "Kích hoạt ví ngay!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 80),
                  new Text(
                    "Kích hoạt",
                    style:
                        TextStyle(fontSize: 18.0, color: CanteenAppTheme.main),
                  )
                ],
              ),
              Expanded(
                child: new Container(
                    alignment: Alignment.topRight,
                    child: new Image.network(
                      "https://icon-library.net/images/online-payment-icon/online-payment-icon-3.jpg",
                      height: 180,
                      width: 100,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
