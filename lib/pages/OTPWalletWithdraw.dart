import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

import 'package:uit_cantin/services/Token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:uit_cantin/models/BankLinked.dart';
import 'package:uit_cantin/pages/WalletInfo.dart';

class OTPWalletTopUpScreen extends StatefulWidget {
  final String amount;
  final String password;
  final BankLinked bankSelect;

  OTPWalletTopUpScreen({Key key, this.amount, this.password, this.bankSelect}) : super(key: key);

  @override
  _OTPWalletTopUpScreen createState() => _OTPWalletTopUpScreen();
}

class _OTPWalletTopUpScreen extends State<OTPWalletTopUpScreen> {
  final TextEditingController _controller = new TextEditingController();
  bool isLoading = false;
  String text = "";
  UserInfo userInfo = new UserInfo();

  @override
  void initState() {
    super.initState();
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
        onTap2: () {
        },
      )
      ..show();
  }

  _topUp() async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_BANK/bank/withdraw';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["amount"] = widget.amount;
    requestBody["card_id"] = widget.bankSelect.cardId.toString();
    requestBody["password"] = widget.password;
    requestBody["otp"] = _controller.text;

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
        Navigator.push(
            context,
            SlideFromLeftPageRoute(
                widget: WalletInfoScreen()
            )
        );
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

  _reSendOTP() async {
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

      } else {
        _showDialog(context, responseBody["message"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading ? _createProgress() : _createBody());
  }

  Widget _createBody() {
    return new SingleChildScrollView(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: new EdgeInsets.all(25.0),
          decoration: BoxDecoration(color: Color(0xFF8A0829)),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(text),
              new Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: new Text("Xác thực OTP",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              new TextField(
                autofocus: false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration: new InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 17.0),
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        borderSide:
                        new BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        borderSide:
                        new BorderSide(color: Colors.white, width: 1.0)),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey, fontSize: 18),
                    hintText: "Mã xác thực",
                    fillColor: Colors.white),
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              new GestureDetector(
                  onTap: () {
                    _topUp();
                  },
                  child: new Container(
                    width: 320.0,
                    height: 50.0,
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      color: const Color(0xFF3B0B17),
                      borderRadius:
                      new BorderRadius.all(const Radius.circular(30.0)),
                    ),
                    child: new Text(
                      "TIẾP TỤC",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                      ),
                    ),
                  )),
              SizedBox(height: 15),
              new GestureDetector(
                onTap: () {
                  _reSendOTP();
                },
                child: new Container(
                  alignment: Alignment.topRight,
                  child: new Text("GỬI LẠI OTP", style: TextStyle(color: Colors.white, fontSize: 15),),
                ),
              )
            ],
          )),
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
