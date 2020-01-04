import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/OTP.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';

import 'package:uit_cantin/services/Token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

class RequireNumberPhoneScreen extends StatefulWidget {
  @override
  _RequireNumberPhone createState() => _RequireNumberPhone();
}

class _RequireNumberPhone extends State<RequireNumberPhoneScreen> {
  final TextEditingController _controller = new TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  YYDialog _showDialog(BuildContext context) {
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
        text: "Đã xảy ra lỗi",
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
        text2: "Thử lại",
        color2: Colors.redAccent,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
        },
      )
      ..show();
  }

  _editPhone() async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_NAME/user/verify-phone';
    var requestBody = new Map<String, dynamic>();

    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };
    requestBody["phone"] = _controller.text;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
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
                widget: OTPScreen(phoneNumber: _controller.text)
            )
        );
      } else {
        _showDialog(context);
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
              new Container(
                width: 100.0,
                height: 100.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage('assets/fork.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: new Text("UIT Căn tin",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              new TextField(
                autofocus: false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration: new InputDecoration(
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
                    hintText: "Nhập số điện thoại",
                    fillColor: Colors.white),
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              new GestureDetector(
                  onTap: () {
                    _editPhone();
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
              SizedBox(height: 10.0),
              new Container(
                child: new Text("Mã xác thực sẽ được gửi cho bạn", style: TextStyle(color: Colors.white, fontSize: 16)),
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
