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
  BankLinked listBank = new BankLinked();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String moneyWithDraw = "0";
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    _fetchBanked().then((data) => setState(() {
      setState(() {
        listBank = data[0];
        print(data);
      });
    }));
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

  _topUp() async {
    var url = '$SERVER_BANK/bank/withdraw';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["amount"] = _textFieldController.text;
    requestBody["card_id"] = listBank.cardId.toString();
    requestBody["password"] = _passwordController.text;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      //  isLoading = false;
      var status = responseBody["status"];
      setState(() {
        isLoading = false;
      });
      if (status == STATUS_SUCCESS) {

       setState(() {
         balance =  ( double.parse(balance) - double.parse( _textFieldController.text)).toString();
       });

      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              createError(responseBody["message"]),
        );
      }
    }
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
                        listBank != null ? new Image.network(
                          listBank.logo != null ? listBank.logo : "",
                          width: 50,
                          height: 40,
                        ) : new Container(),
                        SizedBox(width: 20),
                        new Text(listBank.cardNumber != null ?listBank.cardNumber.substring(0, 4) : ""),
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
                        FormatPrice.getFormatPrice(_textFieldController.text),
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
                        FormatPrice.getFormatPrice("0"),
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
                          FormatPrice.getFormatPrice(_textFieldController.text),
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      flex: 1,
                    )
                  ],
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                         builder: (BuildContext context) => createDialogPassword(),
                    );
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
                            listBank != null ? new Image.network(
                              listBank.logo != null ? listBank.logo : "",
                              width: 50,
                              height: 40,
                            ) : new Container(),
                            SizedBox(width: 20),
                            new Text(listBank.cardNumber != null ?listBank.cardNumber.substring(0, 4) + " ****" : ""),
                            new Expanded(
                                child: new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
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
                            onChanged: (text) {
                              setState(() {
                                moneyWithDraw = text;
                              });
                            },
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
                    Navigator.of(context).pop();
                    _modalConfirm();
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
                            child: new Text("TIẾP TỤC",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                    SizedBox(height: 20),

                  ],
                )));
      },
    );
//    showModalBottomSheet(
//        isScrollControlled: true,
//        context: context,
//        builder: (BuildContext bc) {
//          return Container(
//            height: 210.0,
//            padding: EdgeInsets.all(10.0),
//            width: MediaQuery.of(context).size.width,
//            child: new Column(
//                mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                new Container(
//                  child: new Container(
//                    decoration: BoxDecoration(
//                        border: Border(
//                            bottom: BorderSide(
//                                color: CanteenAppTheme.myGrey, width: 0.5))),
//                    child: new Row(
//                      children: <Widget>[
//                        listBank != null ? new Image.network(
//                          listBank.logo != null ? listBank.logo : "",
//                          width: 50,
//                          height: 40,
//                        ) : new Container(),
//                        SizedBox(width: 20),
//                        new Text(listBank.cardNumber != null ?listBank.cardNumber.substring(0, 4) + " ****" : ""),
//                        new Expanded(
//                            child: new GestureDetector(
//                              onTap: () {
//                                Navigator.of(context).pop();
//                              },
//                              child: new Text(
//                                "Bỏ qua",
//                                textAlign: TextAlign.right,
//                                style: TextStyle(
//                                    color: CanteenAppTheme.main,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            )),
//                      ],
//                    ),
//                  ),
//                ),
//                SizedBox(height: 10.0),
//                new Container(
//                    padding: const EdgeInsets.only(
//                        left: 20, right: 20, bottom: 15),
//                    decoration: BoxDecoration(color: Colors.white),
//                    child: new Padding(
//                      padding: MediaQuery.of(context).viewInsets,
//                      child: new TextField(
//                        controller: _textFieldController,
//                        autofocus: false,
//                        decoration: const InputDecoration(
//                          hintText: '0',
//                          hintStyle:
//                          const TextStyle(color: Colors.grey),
//                        ),
//                        style: const TextStyle(
//                            color: Colors.black, fontSize: 16.0),),
//                    )),
//                new GestureDetector(
//                  onTap: () {
////                    Navigator.of(context).pop();
////                    showDialog(
////                      context: context,
////                      builder: (BuildContext context) => createDialogPassword(),
////                    );
//                  },
//                  child: new Container(
//                    margin: const EdgeInsets.only(
//                        top: 20.0, left: 10.0, right: 10.0),
//                    width: MediaQuery.of(context).size.width,
//                    decoration: BoxDecoration(color: Colors.white),
//                    child: new Container(
//                        width: MediaQuery.of(context).size.width * 0.8,
//                        height: 45.0,
//                        alignment: FractionalOffset.center,
//                        decoration: new BoxDecoration(
//                            color:
//                            _textFieldController.text == "0" || _textFieldController.text == ""
//                                ? Colors.grey
//                                : const Color.fromRGBO(229, 32, 32, 1.0),
//                            borderRadius: new BorderRadius.all(
//                                const Radius.circular(5.0))),
//                        child: new Text("XÁC NHẬN",
//                            style: new TextStyle(
//                              color: Colors.white,
//                              fontSize: 18.0,
//                              fontWeight: FontWeight.bold,
//                              letterSpacing: 0.3,
//                            ))),
//                  ),
//                ),
//                SizedBox(height: 10),
//
//              ],
//            ),
//          );
//        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
//            Container(
//              height: 150,
//              width: MediaQuery.of(context).size.width,
//              decoration: BoxDecoration(color: CanteenAppTheme.main),
//              child: new Column(
//                children: <Widget>[
//                  SizedBox(height: 35),
//                  new Text("Số dư hiện có (VNĐ)",
//                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
//                  SizedBox(height: 15),
//                  new Text(FormatPrice.getFormatPrice(balance),
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 30.0,
//                          fontWeight: FontWeight.bold))
//                ],
//              ),
//            ),
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
