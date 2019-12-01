import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/pages/Recharge.dart';
import 'package:uit_cantin/pages/Home.dart';
import 'package:uit_cantin/models/WalletInfo.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:uit_cantin/pages/test.dart';

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

class WalletInfoScreen extends StatefulWidget {
  @override
  _WalletInfoState createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfoScreen> {

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
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  decoration: BoxDecoration(color: CanteenAppTheme.main),
                ),
                new Container(
                  child: new Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        "Số dư",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      new Row(
                        children: <Widget>[
                          Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  alignment: Alignment.topRight,
                                  child: new Text(
                                    "VNĐ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ))),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                alignment: Alignment.topLeft,
                                child: new Text(
                                  balance,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RechargeScreen()));
                    });
                  },
                  child: new Container(
                      margin:
                      const EdgeInsets.only(top: 150.0, left: 20, right: 20),
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
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                    child: new Image.network(
                                      "https://hanumantmoney.in/images/mobile.png",
                                    )),
                                flex: 1,
                              ),
                              Expanded(
                                child: new Container(
                                  margin: const EdgeInsets.only(left: 15.0),
                                  child: new Text(
                                    "Nạp tiền vào ví để tận hưởng thanh toán không dùng tiền mặt và nhận ưu đãi hấp dẫn",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                flex: 3,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          new Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 7.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: CanteenAppTheme.myGrey,
                                        width: 0.5))),
                            child: new Text(
                              "Nạp tiền",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: CanteenAppTheme.main),
                            ),
                          ),

                        ],
                      )),
                )
              ],
            ),
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: new GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeScreen()));
                        });
                      },
                      child: new Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45.0,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                                color: CanteenAppTheme.main,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0))),
                            child: new Text("TIẾP TỤC MUA HÀNG",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
