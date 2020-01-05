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

import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:uit_cantin/pages/test.dart';
import 'package:uit_cantin/models/BankLinked.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/services/FormatVND.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';
import 'package:uit_cantin/pages/OTPWalletWithdraw.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter/services.dart';

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

List<BankLinked> _parseBankLinked(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<BankLinked>((json) => BankLinked.fromJson(json)).toList();
}

Future<List<BankLinked>> _fetchBanked() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_BANK/bank/get-linked-card',
      headers: requestHeaders);
  return _parseBankLinked(response.body);
}

class RechargeScreen extends StatefulWidget {

  @override
  _RechargeState createState() => _RechargeState();
}

class _RechargeState extends State<RechargeScreen> {

  String balance = "0";
  BankLinked bankSelect = new BankLinked();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String moneyWithDraw = "0";
  bool isLoading;
  List<BankLinked> listBank = [];

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;

  @override
  void initState() {
    isLoading = false;
    _fetchBanked().then((data) => setState(() {
      setState(() {
        listBank = data;
        bankSelect = data[0];
      });
    }));
    _fetchWallet().then((data) => setState(() {
      setState(() {
        balance = data.balance;
      });
    }));
    super.initState();
    _showPersBottomSheetCallBack = _showBottomSheet;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                              _passwordController.text = "";
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
                      controller: _passwordController,
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
                                  _passwordController.text = _passwordController.text + "1";
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
                                  _passwordController.text = _passwordController.text + "2";
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
                                  _passwordController.text = _passwordController.text + "3";
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
                                  _passwordController.text = _passwordController.text + "4";
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
                                  _passwordController.text = _passwordController.text + "5";
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
                                  _passwordController.text = _passwordController.text + "6";
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
                                  _passwordController.text = _passwordController.text + "7";
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
                                  _passwordController.text = _passwordController.text + "8";
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
                                  _passwordController.text = _passwordController.text + "9";
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
                                  _passwordController.text = "";
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
                                  _passwordController.text = _passwordController.text + "0";
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
                                  _passwordController.text = _passwordController.text.substring(0, _passwordController.text.length - 1);
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
                  setState(() {
                    isLoading = true;
                    _topUp();
                  });
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

  _topUp() async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_NAME/user/request-otp';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var response = await http.get(url, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        Navigator.push(
            context,
            SlideFromLeftPageRoute(
                widget: OTPWalletTopUpScreen(
                    amount: _textFieldController.text,
                    bankSelect: bankSelect,
                    password: _passwordController.text)));
      } else {
        _showDialog(context, responseBody["message"]);
      }
    }
  }

  YYDialog _showDialog(BuildContext context, String msg) {
    return YYDialog().build(context)
      ..width = 230
      ..borderRadius = 4.0
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: msg,
        color: Colors.black,
        fontSize: 17.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "Thoát ứng dụng",
        color1: Colors.redAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        text2: "Nhập lại",
        color2: Colors.redAccent,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {},
      )
      ..show();
  }
  Widget createDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 66.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Chọn ngân hàng",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Chọn thẻ",
                style: TextStyle(
                    fontSize: 17,
                    color: CanteenAppTheme.main,
                    fontWeight: FontWeight.bold),
              ),
              new Container(
                child: new Column(
                  children: <Widget>[
                    new ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: listBank.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, position) {
                          return new GestureDetector(
                            onTap: () {
                              setState(() {
                                bankSelect = listBank[position];
                                Navigator.of(context).pop();
                              });
                            },
                            child: new Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: CanteenAppTheme.myGrey,
                                          width: 0.5))),
                              child: new Row(
                                children: <Widget>[
                                  new Image.network(
                                    listBank[position]
                                        .logo,
                                    width: 50,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  new Text(listBank[position]
                                      .cardNumber
                                      .substring(0, 4) +
                                      " **** **** ****"),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createError(message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogErrorContent(context, message),
    );
  }

  dialogErrorContent(BuildContext context, String message) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 66.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Thông báo lỗi",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                message + ". Vui lòng kiểm tra lại thông tin",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 15.0),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
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
                          borderRadius:
                          new BorderRadius.all(const Radius.circular(5.0))),
                      child: new Text("Thử lại",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createDialogPassword() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContentPassword(context),
    );
  }

  dialogContentPassword(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 66.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Nhập mật khẩu cho ví",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              new Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(color: Colors.white),
                  child: new TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    onChanged: (String value) {
                      if (value.length == 6) {
                        Navigator.of(context).pop();
                        setState(() {
                          isLoading = true;
                          _topUp();
                        });
                      }
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  _modalConfirm() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            height: 220.0,
            width: MediaQuery.of(context).size.width,
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: CanteenAppTheme.myGrey, width: 0.5))),
                    child: new Row(
                      children: <Widget>[
                        bankSelect != null ? new Image.network(
                          bankSelect.logo != null ? bankSelect.logo : "",
                          width: 50,
                          height: 40,
                        ) : new Container(),
                        SizedBox(width: 20),
                        new Text(bankSelect.cardNumber != null ?bankSelect.cardNumber.substring(0, 4) : ""),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: new Text(
                                "Hủy",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: CanteenAppTheme.main,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                new Row(
                  children: <Widget>[
                    Expanded(
                        child: new Text(
                          "SỐ TIỀN",
                          textAlign: TextAlign.right,
                        ),
                        flex: 2),
                    Expanded(
                      child: new Text(
                        FormatVND.getFormatPrice(_textFieldController.text),
                        textAlign: TextAlign.right,
                      ),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(height: 7.0),
                new Row(
                  children: <Widget>[
                    Expanded(
                        child: new Text(
                          "PHÍ GIAO DỊCH",
                          textAlign: TextAlign.right,
                        ),
                        flex: 2),
                    Expanded(
                      child: new Text(
                        FormatVND.getFormatPrice("0"),
                        textAlign: TextAlign.right,
                      ),
                      flex: 1,
                    )
                  ],
                ),
                new Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.4),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: CanteenAppTheme.myGrey, width: 1))),
                ),
                SizedBox(height: 7.0),
                new Row(
                  children: <Widget>[
                    Expanded(
                        child: new Text(
                          "NHẬN ĐƯỢC",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        flex: 2),
                    Expanded(
                      child: new Text(
                          FormatVND.getFormatPrice(_textFieldController.text),
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      flex: 1,
                    )
                  ],
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showPersBottomSheetCallBack();
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
                            color: const Color.fromRGBO(229, 32, 32, 1.0),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(5.0))),
                        child: new Text("XÁC NHẬN",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ))),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _withdraw() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                child: Wrap(
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: CanteenAppTheme.myGrey, width: 0.5))),
                        child: new Row(
                          children: <Widget>[
                            bankSelect != null ? new Image.network(
                              bankSelect.logo != null ? bankSelect.logo : "",
                              width: 50,
                              height: 40,
                            ) : new Container(),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      createDialog(),
                                );
                              },
                              child: new Text(bankSelect.cardNumber != null ?bankSelect.cardNumber.substring(0, 4) + " ****" : ""),
                            ),
                            new Expanded(
                                child: new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _textFieldController.text = "";
                                  },
                                  child: new Text(
                                    "Bỏ qua",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: CanteenAppTheme.main,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 15),
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new TextField(
                            controller: _textFieldController,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '0',
                              hintStyle:
                              const TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16.0),),
                        )),
                    new GestureDetector(
                      onTap: () {
                        if (_textFieldController.text != "") {
                          Navigator.of(context).pop();
                          _modalConfirm();
                        }
                      },
                      child: new Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
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
                            child: new Text("TIẾP TỤC",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ],
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160.0),
        child: GradientAppBar(
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomPaint(
                painter: CircleOne(),
              ),
              CustomPaint(
                painter: CircleTwo(),
              ),
            ],
          ),
          title: Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Ví của bạn",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              )
          ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: new GestureDetector(
            onTap: () {
                _withdraw();
            },
            child: new Text("Rút tiền", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
          ),
        ),
      ],
          elevation: 0,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CanteenAppTheme.HeaderBlueDark, CanteenAppTheme.HeaderBlueLight],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(8),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CanteenAppTheme.HeaderGreyLight,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Số dư hiện tại ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    FormatPrice.getFormatPrice(balance),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      body: isLoading ? _createProgress() : _createBody(),
    );
  }

  Widget _createBody() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      color: Color(0xFFE6E6E6),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          new GestureDetector(
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    SlideFromLeftPageRoute(
                        widget: RechargeInfoScreen()
                    )
                );
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
    );
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }
}
