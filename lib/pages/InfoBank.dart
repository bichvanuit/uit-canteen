import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/models/BankInfo.dart';
import 'package:uit_cantin/models/BankInfoLink.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/pages/WalletInfo.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

List<BankInfo> _parseBank(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<BankInfo>((json) => BankInfo.fromJson(json)).toList();
}

Future<List<BankInfo>> _fetchBank() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_BANK/bank/get-bank-list',
      headers: requestHeaders);
  return _parseBank(response.body);
}

class InfoBankScreen extends StatefulWidget {
  @override
  _InfoBankState createState() => _InfoBankState();
}

class _InfoBankState extends State<InfoBankScreen> {
  List<BankInfo> listBank;
  List<Color> listColor;
  bool isLoading;
  BankInfoLink info = new BankInfoLink();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController _controllerCardName = new TextEditingController();
  final TextEditingController _controllerCardNumber =
      new TextEditingController();
  final TextEditingController _controllerCardDate = new TextEditingController();

  @override
  void initState() {
    isLoading = false;
    _fetchBank().then((data) => setState(() {
          setState(() {
            listBank = data;
            info.bankId = listBank[0].bankId.toString();
            info.cardTypeId = "1";
            _resetBorder();
            listColor[0] = CanteenAppTheme.main;
            _controllerCardNumber.text = "9704800842070970";
            _controllerCardName.text = "LUONG THI BICH VAN";
            _controllerCardDate.text = "01/17";
          });
        }));
    super.initState();
  }

  _resetBorder() {
    listColor = [];
    for (int i = 0; i < listBank.length; i++) {
      listColor.add(CanteenAppTheme.myGrey);
    }
  }

  _onChangeBank(BankInfo bank) {
    setState(() {
      _resetBorder();
      listColor[listBank.indexOf(bank)] = CanteenAppTheme.main;
      info.bankId = bank.bankId.toString();
    });
  }

  _linkBank() async {
    info.cardNumber = _controllerCardNumber.text;
    info.cardholderName = _controllerCardName.text;
    info.validFrom = _controllerCardDate.text;
    var url = '$SERVER_BANK/bank/link-card';

    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };
    var response =
        await http.post(url, body: info.toMap(), headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
      var status = responseBody["status"];

      if (status == STATUS_SUCCESS) {
        setState(() {
          Navigator.push(
              context,
              SlideFromLeftPageRoute(
                  widget: WalletInfoScreen()
              )
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              createDialog(responseBody["message"]),
        );
      }
    }
  }

  Widget createDialog(String message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, message),
    );
  }

  dialogContent(BuildContext context, String message) {
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

  @override
  void dispose() {
    super.dispose();
  }

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
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Widget _createBody() {
    return new Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "1. Chọn ngân hàng",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          listBank != null
              ? new Container(
                  height: 100.0,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listBank.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, position) {
                        return GestureDetector(
                          onTap: () {
                            _onChangeBank(listBank[position]);
                          },
                          child: new Container(
                            height: 60,
                            width: 90,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: listColor[position], width: 2.0)),
                            margin: const EdgeInsets.all(5.0),
                            child: new Image.network(
                              listBank[position].logo,
                              width: 90,
                              height: 60,
                            ),
                          ),
                        );
                      }),
                )
              : new Container(),
          SizedBox(
            height: 10,
          ),
          new Text(
            "2. Nhập thông tin",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          new Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _controllerCardName,
                      decoration: InputDecoration(
                        labelText: "Nhập tên chủ thẻ",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return "Bạn chưa nhập tên chủ thẻ";
                        return null;
                      }),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      controller: _controllerCardNumber,
                      decoration: InputDecoration(
                        labelText: "Nhập số thẻ",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return "Bạn chưa nhập số thẻ";
                        return null;
                      }),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _controllerCardDate,
                      decoration: InputDecoration(
                        labelText: "Nhập ngày mở thẻ",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return "Bạn chưa nhập ngày mở thẻ";
                        return null;
                      }),
                ),
              ],
            ),
          ),
          new Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: new GestureDetector(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                        _linkBank();
                      });
                    }
                  },
                  child: new Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
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

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }
}
