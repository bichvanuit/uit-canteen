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
import 'package:uit_cantin/models/Transaction.dart';
import 'package:uit_cantin/services/FormatVND.dart';
import 'package:uit_cantin/models/BankLinked.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';

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

List<Transaction> _parseCategory(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<Transaction>((json) => Transaction.fromJson(json)).toList();
}

Future<List<Transaction>> _fetchTransactionList() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response =
  await http.get('$SERVER_BANK/transaction/list', headers: requestHeaders);
  List<Transaction> listCategory = _parseCategory(response.body);

  return listCategory;
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

class WalletInfoScreen extends StatefulWidget {
  @override
  _WalletInfoState createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfoScreen> {
  String balance = "0";
  List<Transaction> listTracsaction = [];
  List<BankLinked> listBank = [];
  BankLinked bankSelect = new BankLinked();
  bool isLoading = false;

  @override
  void initState() {
    _fetchWallet().then((data) =>
        setState(() {
          setState(() {
            balance = data.balance;
          });
        }));

    _fetchTransactionList().then((data) {
      setState(() {
        listTracsaction = data;
      });
    });

    _fetchBanked().then((data) => setState(() {
      setState(() {
        listBank = data;
        print(data);
      });
    }));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  YYDialog _showDialog() {
    return YYDialog().build()
      ..width = 300
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
        text: "Bạn có chắc chắn muốn hủy liên kết với " + bankSelect.bankName,
        color: Colors.black,
        fontSize: 17.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "Hủy",
        color1: Colors.redAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
        },
        text2: "Tiếp tục",
        color2: Colors.redAccent,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          _unLink();
        },
      )
      ..show();
  }

  _unLink() async {
    print('----------------------');
    var url = '$SERVER_BANK/bank/unlink-card';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["card_id"] = bankSelect.cardId;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    print(response.body);

    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      //  isLoading = false;
      var status = responseBody["status"];
      print(responseBody);
      setState(() {
        isLoading = false;
      });
      if (status == STATUS_SUCCESS) {
        print('----------------------');
      } else {
//        showDialog(
//          context: context,
//          builder: (BuildContext context) =>
//              createError(responseHuyBody["message"]),
//        );
      }
    }
  }
  Widget createDialogConfirm() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContentConfirm(context),
    );
  }

  dialogContentConfirm(BuildContext context) {
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
                "Bạn có chắc chắn muốn hủy liên kết với " + bankSelect.bankName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new GestureDetector(
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
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0)),
                                border:
                                Border.all(color: Colors.grey, width: 2.0)),
                            child: new Text("Thoát",
                                style: new TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _unLink();
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
                            child: new Text("TIếp tục",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        createDialogConfirm(),
                                );
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

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Widget _createBody() {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 150.0,
                decoration: BoxDecoration(color: CanteenAppTheme.main),
              ),
              new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Số dư",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    new Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        alignment: Alignment.center,
                        child: new Text(
                          FormatVND.getFormatPrice(balance),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ],
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RechargeScreen()));
                  });
                },
                child: new Container(
                    margin: const EdgeInsets.only(
                        top: 120.0, left: 20, right: 20),
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    height: 145.0,
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
                        SizedBox(
                          height: 10.0,
                        ),
                        new Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
          SizedBox(height: 10),
          new Container(
            height: 300,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.only(left: 16) ,
                      child: new Text(
                        "Hoạt động gần đây",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: CanteenAppTheme.myGreyTitle,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                createDialog(),
                          );
                        },
                        child: new Container(
                            margin: const EdgeInsets.only(top: 10.0, right: 10),
                            alignment: Alignment.topRight,
                            child: new Text(
                              "Hủy liên kết",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: CanteenAppTheme.main),
                            )),
                      ),
                    ),

                  ],
                ),
                new Container(
                  height: 250,
                  margin: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      color: CanteenAppTheme.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: CanteenAppTheme.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 5.0),
                      ]),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: listTracsaction.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int position) {
                      return new Container(
                        margin: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: CanteenAppTheme.myGrey, width: 1.0))
                        ),
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(listTracsaction[position]
                                        .transactionTypeName, style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),),
                                    SizedBox(height: 10),
                                    new Text(listTracsaction[position].bankName,
                                      style: TextStyle(
                                          color: CanteenAppTheme.grey,
                                          fontSize: 16),),
                                  ],
                                )
                            ),
                            new Expanded(
                                child:
                                new Text(FormatVND.getFormatPrice(listTracsaction[position].amount),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      });
                    },
                    child: new Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 10.0, right: 10.0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: new Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
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
          ),
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
