import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/InfoBank.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/pages/InfoBank.dart';

class ConfirmTeleNumnerScreen extends StatefulWidget {
  @override
  _ConfirmTeleNumnerState createState() => _ConfirmTeleNumnerState();
}

class _ConfirmTeleNumnerState extends State<ConfirmTeleNumnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          //  title: appBarTitle,
          iconTheme: new IconThemeData(color: Colors.white),
          //  leading: _isSearching ? const BackButton() : null,
          title: Text("Chọn ngân hàng"),
        ),
        body: SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: new Column(
              children: <Widget>[
                new Text(
                  "Vui lòng kiểm tra số điện thoại dùng để liên kết ví",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Color(0xFFF8E0E6),
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "0352107018",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3.0),
                      new Text(
                        "Đối với các ngân hàng BIDV, HDBank, MBBank, OCB, SHB, Vietcombank, Vietinbank số điện thoại phải trùng với số điện thoại đăng ký tài khoản thẻ ngân hàng",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                new GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoBankScreen()));
                    });
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white),
                    child: new Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45.0,
                        alignment: FractionalOffset.center,
                        decoration: new BoxDecoration(
                            color: const Color.fromRGBO(229, 32, 32, 1.0),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(5.0))),
                        child: new Text("Tiếp tục",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ))),
                  ),
                ),
                SizedBox(height: 20.0),
                new Text(
                  "Bấm đồng ý, tôi đã đồng ý Điều kiện và điều khoản sử dụng của ....",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height:  30.0,),
                new Text("Không sử dụng số điện thoại trên",
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ));
  }
}
