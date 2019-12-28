import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/InfoBank.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

class BankScreen extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<BankScreen> {
  TextEditingController textController = TextEditingController();
  bool isLoading;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
      return new Container(
          decoration: new BoxDecoration(
              color: CanteenAppTheme.white,
              borderRadius:
              BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: CanteenAppTheme.grey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 5.0),
              ]),
          height: MediaQuery.of(context).size.height - 200,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Text(
                          "MW",
                          style: TextStyle(
                              color: CanteenAppTheme.main,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                    new Expanded(
                        child: new GestureDetector(
                            onTap: () {
                              textController.text = "";
                              Navigator.of(context).pop();
                            },
                            child: new Text(
                              "Hủy",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )))
                  ],
                ),
              ),
              new Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 15),
                  decoration: BoxDecoration(color: Colors.white),
                  child: new TextField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      controller: textController,
                      obscureText: true,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(
                          color: Colors.black, fontSize: 30.0),
                      onChanged: (String value) {
                        // note = value;
                      })),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      textController.text = textController.text + "1";
                                    });
                                  },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "1",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "2";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "2",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "3";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "3",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "4";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "4",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "5";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "5",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "6";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "6",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "7";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "7",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "8";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "8",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "9";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "9",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = "";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "Clear",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text + "0";
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: new Text(
                                    "0",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  textController.text = textController.text.substring(0, textController.text.length - 1);
                                });
                              },
                              child: new Container(
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: CanteenAppTheme.myGrey,
                                            width: 1.0))),
                                child: new Center(
                                  child: Icon(Icons.backspace),
                                ),
                              ),
                            ))
                      ],
                    ),

                  ],
                ),
              ),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _activeWallet();
                },
                child: new Container(
                  margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: new Container(
                      height: 45.0,
                      alignment: FractionalOffset.center,
                      decoration: new BoxDecoration(
                          color: const Color.fromRGBO(229, 32, 32, 1.0),
                          borderRadius:
                          new BorderRadius.all(const Radius.circular(5.0))),
                      child: new Text("Xác nhận",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ))),
                ),
              )
            ],
          ));
    })
        .closed
        .whenComplete(() {
      if (mounted) {
        setState(() {
          _showPersBottomSheetCallBack = _showBottomSheet;
        });
      }
    });
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
    _showPersBottomSheetCallBack = _showBottomSheet;
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  _activeWallet() async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_NAME/user-wallet/activate';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["password"] = textController.text;

    var response =
    await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    setState(() {
      isLoading = false;
    });
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => new InfoBankScreen(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 2000),
          ),
        );
      } else {}
    }
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }

  Widget _createBody() {
    return new Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: new Column(
        children: <Widget>[
          new Text(
            "Kích hoạt thành công bạn có thể",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: new Row(
                    children: <Widget>[
                      Image.network(
                        "https://cdn5.vectorstock.com/i/1000x1000/33/44/money-transaction-icon-vector-21023344.jpg",
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        "Sử dụng số dư",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: new Row(
                    children: <Widget>[
                      Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSMoS4gf_odiCXmG9iWyysSrorFtKhX4r1sdUsAjugz3u6geAwo",
                        width: 30,
                        height: 30,
                      ),
                      Text("Giao dịch an toàn",
                          style: TextStyle(fontSize: 17))
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: new GestureDetector(
                  onTap: () {
                    _showPersBottomSheetCallBack();
                  },
                  child: new Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white),
                    child: new Container(
                        height: 45.0,
                        alignment: FractionalOffset.center,
                        decoration: new BoxDecoration(
                            color: const Color.fromRGBO(229, 32, 32, 1.0),
                            borderRadius:
                            new BorderRadius.all(const Radius.circular(5.0))),
                        child: new Text("Tiếp tục",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ))),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Liên kết"),
        ),
        body: isLoading == true ? _createProgress() : _createBody());
  }
}
