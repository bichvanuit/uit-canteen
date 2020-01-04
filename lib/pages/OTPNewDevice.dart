import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/Home.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

import 'package:uit_cantin/services/Token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

class OTPNewDeviceScreen extends StatefulWidget {
  @override
  _OTPNewDevice createState() => _OTPNewDevice();
}

class _OTPNewDevice extends State<OTPNewDeviceScreen> {
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
        onTap2: () {},
      )
      ..show();
  }

  _verifyPhone() async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_NAME/user/verify-device-otp';
    var requestBody = new Map<String, dynamic>();

    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };
    requestBody["otp"] = _controller.text;

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
                widget: HomeScreen()
            )
        );
      } else {
        _showDialog(context);
      }
    }

    Navigator.push(
        context,
        SlideFromLeftPageRoute(
            widget: HomeScreen()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: isLoading ? _createProgress() : _createBody());
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
                    _verifyPhone();
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
                child: new Container(
                  alignment: Alignment.topRight,
                  child: new Text(
                    "GỬI LẠI OTP",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
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
