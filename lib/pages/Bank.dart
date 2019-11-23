import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:uit_cantin/pages/InfoBank.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';

class BankScreen extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<BankScreen> {
  TextEditingController controller = TextEditingController();
  int pinLength = 6;

  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  _activeWallet(String pin) async {
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
    requestBody["password"] = pin;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        isLoading = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InfoBankScreen()));
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
    return SingleChildScrollView(
      child: new Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: new Column(
          children: <Widget>[
//                new Text(
//                  "Các ngân hàng đã hổ trợ",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                ),
//                SizedBox(height: 10.0),
//                new Container(
//                  child: new Image.network(
//                      "https://www.webico.vn/wp-content/uploads/2017/08/banknet-bank.png"),
//                ),
//                SizedBox(height: 20.0),
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
//                Container(
//                  padding: const EdgeInsets.all(10.0),
//                  decoration: new BoxDecoration(
//                    color: Color(0xFFF8E0E6),
//                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                  ),
//                  child: new Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      new Text(
//                        "Bạn có thể dùng những loại thẻ sau để liên kết",
//                        style: TextStyle(fontSize: 16),
//                      ),
//                      SizedBox(height: 3.0),
//                      new Text(
//                          "- Thẻ ATM được phát hành bởi các ngân hàng hợp tác với Moca", style: TextStyle(fontSize: 16)),
//                      new Text(
//                          "- Thẻ ghi nợ quốc tế (Visa / MasterCard / JCB / Amex) được phát hành bởi ngân hàng MSB, SCB, SHB hoặc VietCombank.", style: TextStyle(fontSize: 16)),
//                      SizedBox(height: 3.0),
//                      new Text(
//                          "Xin lưu ý, theo quy định của Ngân hàng Nhà nước Việt Nam, bạn không thể sử dụng thẻ tín dụng để liên kết với ví điện tử",
//                          style: TextStyle(fontSize: 16))
//                    ],
//                  ),
//                ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0, top: 20.0),
              child: Text(
                "Nhập mật khẩu cho ví",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            PinCodeTextField(
              autofocus: false,
              controller: controller,
              hideCharacter: true,
              highlight: true,
              highlightColor: Colors.blue,
              defaultBorderColor: Colors.black,
              hasTextBorderColor: Colors.green,
              maxLength: pinLength,
              maskCharacter: "*",
              onDone: (text) {
                _activeWallet(text);
              },
              pinCodeTextFieldLayoutType:
              PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
              wrapAlignment: WrapAlignment.start,
              pinBoxDecoration:
              ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
              pinTextStyle: TextStyle(fontSize: 30.0),
              pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
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
        body: isLoading == true ? _createProgress() : _createBody());
  }
}
