import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/pages/Bank.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<WalletScreen> {
  bool _value1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          //  title: appBarTitle,
          iconTheme: new IconThemeData(color: Colors.white),
          //  leading: _isSearching ? const BackButton() : null,
          title: Text("Liên kết"),
        ),
        body: new Container(
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BankScreen()));
                  });
                },
                child: new Container(
                    decoration: BoxDecoration(color: CanteenAppTheme.main),
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 10.0, 10.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            child: new Icon(
                              Icons.payment,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        new Expanded(
                            flex: 5,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "Thêm liên kết",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                new Text(
                                  "Thêm thẻ tín dụng, thẻ ghi nợ hoặc tài khoản ngân hàng",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            child: new Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    )),
              ) ,
              new Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: new Text("ĐÃ LIÊN KẾT (1)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Image.network("https://img.123pay.vn/imgnew123payvn/images/123be/TheMaritime.jpg", fit: BoxFit.cover,),
              ),
            ],
          ),
        ));
  }
}
