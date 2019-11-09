import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/pages/Recharge.dart';

class WalletInfoScreen extends StatefulWidget {
  @override
  _WalletInfoState createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfoScreen> {
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
                                  "100.000",
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
            )
          ],
        ),
      ),
    );
  }
}
