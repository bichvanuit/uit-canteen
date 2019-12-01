import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/models/WalletInfo.dart';
import 'package:uit_cantin/pages/Recharge.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';

Future<WalletInfo> _fetchWallet() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response =
      await http.get('$SERVER_NAME/user-wallet/info', headers: requestHeaders);
  final parsed = json.decode(response.body)["data"];
  return WalletInfo.fromJson(parsed);
}

class AdvertisementWall extends StatefulWidget {
  _AdvertisementWall createState() => _AdvertisementWall();
}

class _AdvertisementWall extends State<AdvertisementWall> {
  String strHello = "";
  DateTime now = DateTime.now();
  int isActive = 0;
  WalletInfo walletInfo = new WalletInfo();

  @override
  initState() {
    _fetchWallet().then((data) => setState(() {
          setState(() {
            walletInfo = data;
          });
        }));
    var hour = now.hour;
    if (hour >= 0 && hour < 11) {
      strHello = "Chúc buổi sáng an lành";
    } else if (hour >= 11 && hour < 13) {
      strHello = "Chúc buổi trưa vui vẻ";
    } else if (hour >= 13 && hour < 18) {
      strHello = "Chúc buổi chiều vui vẻ";
    } else {
      strHello = "Chúc buổi tối ấm áp";
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget createLayoutNoActice() {
    return new Row(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Kích hoạt ví ngay!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 80),
            new Text(
              "Kích hoạt",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: CanteenAppTheme.main),
            ),
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
    );
  }

  Widget createLayoutActive() {
    return new Column(
      children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: new Text(
                "Số dư",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            new Expanded(
              child: new Text(
                FormatPrice.getFormatPrice(
                    walletInfo.balance == null ? "0" : walletInfo.balance),
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: CanteenAppTheme.main),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        new Container(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RechargeScreen()));
                  });
                },
                child: new Container(
                    height: 70,
                    width: 70,
                    padding: const EdgeInsets.only(top: 10),
                    //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: CanteenAppTheme.myGrey, width: 2)),
                    child: new Column(
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          color: CanteenAppTheme.main,
                          size: 30.0,
                        ),
                        new Text("Nạp tiền")
                      ],
                    )),
              ),
//              new GestureDetector(
//                onTap: () {
//                  setState(() {
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => RechargeScreen()));
//                  });
//                },
//                child: new Container(
//                    height: 70,
//                    width: 70,
//                    padding: const EdgeInsets.only(top: 10),
//                    //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                    decoration: BoxDecoration(
//                        border: Border.all(
//                            color: CanteenAppTheme.myGrey, width: 2)),
//                    child: new Column(
//                      children: <Widget>[
//                        Icon(
//                          Icons.money_off,
//                          color: CanteenAppTheme.main,
//                          size: 30.0,
//                        ),
//                        new Text("Rút tiền")
//                      ],
//                    )),
//              ),
              new GestureDetector(
                  onTap: () {},
                  child: new Container(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: CanteenAppTheme.myGrey, width: 2)),
                      child: new Column(
                        children: <Widget>[
                          Icon(
                            Icons.history,
                            color: CanteenAppTheme.main,
                            size: 30.0,
                          ),
                          Text("Lịch sử")
                        ],
                      )))
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          height: 120.0,
          padding: const EdgeInsets.only(top: 25.0),
          decoration: BoxDecoration(color: CanteenAppTheme.main),
          child: new Text(
            strHello,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
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
          child: walletInfo.isActive == 0
              ? createLayoutNoActice()
              : createLayoutActive(),
        ),
      ],
    );
  }
}
