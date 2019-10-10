import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/pages/Bank.dart';

class InfoBankScreen extends StatefulWidget {
  @override
  _InfoBankState createState() => _InfoBankState();
}

class _InfoBankState extends State<InfoBankScreen> {
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
        body: SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: new Column(
              children: <Widget>[
                new Container(
                  child: Image.asset('assets/atm.png'),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      style: TextStyle(
                          color:
                          Colors.grey),
                      decoration:
                      InputDecoration(
                        labelText:
                        "Nhập số thẻ",
                        labelStyle: TextStyle(
                            color:
                            Colors.grey),
                        enabledBorder:
                        const UnderlineInputBorder(
                          borderSide:
                          const BorderSide(
                              color: Colors
                                  .grey,
                              width: 0.0),
                        ),
                      ),
                      validator:
                          (String value) {
                        if (value.isEmpty)
                          return "Bạn chưa nhập số thẻ";
                        return null;
                      }),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      style: TextStyle(
                          color:
                          Colors.grey),
                      decoration:
                      InputDecoration(
                        labelText:
                        "Ngày phát hành (mm/yy)",
                        labelStyle: TextStyle(
                            color:
                            Colors.grey),
                        enabledBorder:
                        const UnderlineInputBorder(
                          borderSide:
                          const BorderSide(
                              color: Colors
                                  .grey,
                              width: 0.0),
                        ),
                      ),
                      validator:
                          (String value) {
                        if (value.isEmpty)
                          return "Bạn chưa nhập ngày phát hành";
                        return null;
                      }),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      style: TextStyle(
                          color:
                          Colors.grey),
                      decoration:
                      InputDecoration(
                        labelText:
                        "Nhập tên chủ thẻ",
                        labelStyle: TextStyle(
                            color:
                            Colors.grey),
                        enabledBorder:
                        const UnderlineInputBorder(
                          borderSide:
                          const BorderSide(
                              color: Colors
                                  .grey,
                              width: 0.0),
                        ),
                      ),
                      validator:
                          (String value) {
                        if (value.isEmpty)
                          return "Bạn chưa nhập tên chủ thẻ";
                        return null;
                      }),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: new Container(
                      height: 45.0,
                      alignment: FractionalOffset.center,
                      decoration: new BoxDecoration(
                          color: const Color.fromRGBO(
                              229, 32, 32, 1.0),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(5.0))),
                      child: new Text("Tiếp tục",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ))),
                ),
              ],
            ),
          ),
        ));
  }
}
