import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/pages/RechargeInfo.dart';
import 'package:uit_cantin/models/WalletInfo.dart';
import 'package:uit_cantin/services/FormatPrice.dart';

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
  final response = await http.get('$SERVER_NAME/user-wallet/info',
      headers: requestHeaders);
  final parsed = json.decode(response.body)["data"];
  return WalletInfo.fromJson(parsed);
}

class RechargeScreen extends StatefulWidget {

  @override
  _RechargeState createState() => _RechargeState();
}

class _RechargeState extends State<RechargeScreen> {

  String balance = "0";
  @override
  void initState() {
    _fetchWallet().then((data) => setState(() {
      setState(() {
        balance = data.balance;
      });
    }));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFE6E6E6),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: CanteenAppTheme.main),
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 35),
                  new Text("Số dư hiện có (VNĐ)",
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  SizedBox(height: 15),
                  new Text(FormatPrice.getFormatPrice(balance),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: new Text(
                  "Phương thức thanh toán mặc định của bạn",
                  style: TextStyle(fontSize: 17),
                )),
            SizedBox(height: 10.0),
            new GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RechargeInfoScreen()));
                });
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("Nạp tiền qua",
                          style: TextStyle(
                              color: CanteenAppTheme.main,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      SizedBox(
                        height: 8.0,
                      ),
                      new Text(
                        "Với phương thức khác",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
