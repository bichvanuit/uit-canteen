import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/compoments/DialogMethodRecharge.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/models/BankLinked.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/pages/WalletInfo.dart';
import 'package:uit_cantin/pages/RechargeSuccess.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';

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

class RechargeInfoScreen extends StatefulWidget {
  @override
  _RechargeInfoState createState() => _RechargeInfoState();
}

class _RechargeInfoState extends State<RechargeInfoScreen> {
  List<BankLinked> listBank = [];
  BankLinked bankSelect = new BankLinked();
  bool isLoading = false;

  @override
  void initState() {
    isLoading = false;
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
    isLoading = false;
    super.dispose();
  }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String strBank = "";
  String strBankName = "";

  List<Color> listColor = [Colors.white, Colors.white, Colors.white];

  _onPress(String value) {
    List<Color> listColor = [Colors.white, Colors.white, Colors.white];
    setState(() {
      _textFieldController.text = value;
      switch (value) {
        case "10000":
          listColor[0] = Color(0xFFA9F5F2);
          break;
        case "50000":
          listColor[1] = Color(0xFFA9F5F2);
          break;
        case "100000":
          listColor[2] = Color(0xFFA9F5F2);
          break;
        default:
          break;
      }
    });
  }

  _topUp() async {
    var url = '$SERVER_BANK/bank/top-up';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["amount"] = _textFieldController.text;
    requestBody["card_id"] = bankSelect.cardId.toString();
    requestBody["password"] = _passwordController.text;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    print (response.body);
    print (response.statusCode);
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      //  isLoading = false;
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        setState(() {
          isLoading = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RechargeSuccessScreen()));
        });

      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => createError(responseBody["message"]),
        );
      }
    }
  }

  Widget createError(message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
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
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(5.0))),
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


  Widget createDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
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
          padding: EdgeInsets.only(
            top: Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
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
                "Chọn phương thức thanh toán",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                child: new Text(
                  "Theo quy định của pháp luật Việt Nam, bạn không thẻ nạp tiền trực tiếp từ thẻ tín dụng vào ví điện từ",
                  style: TextStyle(fontStyle: FontStyle.italic),
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
                                strBank =
                                    "https://htcamera.vn/wp-content/uploads/Logo-MSB.jpg";
                                strBankName = "8548";
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
                                    "https://htcamera.vn/wp-content/uploads/Logo-MSB.jpg",
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
//              Text(
//                "Khác",
//                style: TextStyle(
//                    fontSize: 17,
//                    color: CanteenAppTheme.main,
//                    fontWeight: FontWeight.bold),
//              ),
//              new Container(
//                child: new Column(
//                  children: <Widget>[
//                    new GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          strBank =
//                              "https://cdn.vox-cdn.com/thumbor/GkcUPA-j2Lv9hGqJ53NDyjTLVoM=/0x0:1000x793/1200x800/filters:focal(420x317:580x477)/cdn.vox-cdn.com/uploads/chorus_image/image/62856083/mastercard_logo.1547665179.png";
//                          strBankName = "MasterCard";
//                          Navigator.of(context).pop();
//                        });
//                      },
//                      child: new Container(
//                        decoration: BoxDecoration(
//                            border: Border(
//                                bottom: BorderSide(
//                                    color: CanteenAppTheme.myGrey,
//                                    width: 0.5))),
//                        child: new Row(
//                          children: <Widget>[
//                            new Image.network(
//                              "https://cdn.vox-cdn.com/thumbor/GkcUPA-j2Lv9hGqJ53NDyjTLVoM=/0x0:1000x793/1200x800/filters:focal(420x317:580x477)/cdn.vox-cdn.com/uploads/chorus_image/image/62856083/mastercard_logo.1547665179.png",
//                              width: 50,
//                              height: 40,
//                            ),
//                            SizedBox(
//                              width: 20,
//                            ),
//                            new Text("MasterCard"),
//                          ],
//                        ),
//                      ),
//                    ),
//                    new GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          strBank =
//                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRAOFQH3oIQXdRsIDo_fCK6ikaS-JDcLn0nm3fxYqUM0SoAuxf1";
//                          strBankName = "Visa";
//                          Navigator.of(context).pop();
//                        });
//                      },
//                      child: new Container(
//                        decoration: BoxDecoration(
//                            border: Border(
//                                bottom: BorderSide(
//                                    color: CanteenAppTheme.myGrey,
//                                    width: 0.5))),
//                        child: new Row(
//                          children: <Widget>[
//                            new Image.network(
//                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRAOFQH3oIQXdRsIDo_fCK6ikaS-JDcLn0nm3fxYqUM0SoAuxf1",
//                              width: 50,
//                              height: 40,
//                            ),
//                            SizedBox(
//                              width: 20,
//                            ),
//                            new Text("Visa"),
//                          ],
//                        ),
//                      ),
//                    ),
//                    new GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          strBank =
//                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS4Ip1jyWkeb6crA-yOvWkUsC2OGbBrv1YsXkoqhiKMJCtahlt0";
//                          strBankName = "JCB";
//                          Navigator.of(context).pop();
//                        });
//                      },
//                      child: new Container(
//                        decoration: BoxDecoration(
//                            border: Border(
//                                bottom: BorderSide(
//                                    color: CanteenAppTheme.myGrey,
//                                    width: 0.5))),
//                        child: new Row(
//                          children: <Widget>[
//                            new Image.network(
//                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS4Ip1jyWkeb6crA-yOvWkUsC2OGbBrv1YsXkoqhiKMJCtahlt0",
//                              width: 50,
//                              height: 40,
//                            ),
//                            SizedBox(width: 20),
//                            new Text("JCB"),
//                          ],
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//              )
            ],
          ),
        ),
      ],
    );
  }

  Widget createDialogPassword() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
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
          padding: EdgeInsets.only(
            top: Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
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
                  padding:
                      const EdgeInsets.only( bottom: 15),
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
                      if (value.length == 6 ) {
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
                        new Image.network(
                          strBank,
                          width: 50,
                          height: 40,
                        ),
                        SizedBox(width: 20),
                        new Text(bankSelect.cardNumber.substring(0, 4)),
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
                          "TỔNG CỘNG",
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
                            color:
                                strBank == "" || _textFieldController.text == ""
                                    ? Colors.grey
                                    : const Color.fromRGBO(229, 32, 32, 1.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: CanteenAppTheme.main,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text("Nạp tiền"),
      ),
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Widget _createBody() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      color: Color(0xFFE6E6E6),
      child: new Column(
        children: <Widget>[
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                new Text(
                  "1. Chọn số tiền muốn nạp (VNĐ)",
                  style: TextStyle(fontSize: 17.0),
                ),
                SizedBox(
                  height: 15.0,
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new GestureDetector(
                        onTap: () {
                          _onPress("10000");
                        },
                        child: new Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              color: listColor[0],
                              border:
                                  Border.all(color: Colors.grey, width: 1.0)),
                          child: new Text(
                            "10.000",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                      new Expanded(
                          child: new GestureDetector(
                        onTap: () {
                          _onPress("50000");
                        },
                        child: new Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              color: listColor[1],
                              border:
                                  Border.all(color: Colors.grey, width: 1.0)),
                          child: new Text("50.000",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )),
                      new Expanded(
                          child: new GestureDetector(
                        onTap: () {
                          _onPress("100000");
                        },
                        child: new Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              color: listColor[2],
                              border:
                                  Border.all(color: Colors.grey, width: 1.0)),
                          child: new Text("100.000",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ))
                    ],
                  ),
                ),
                new Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(color: Colors.white),
                    child: new TextField(
                      controller: _textFieldController,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: 'Ví dụ: 10000',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
                    )),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => createDialog(),
              );
            },
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("2. Chọn phương thức thanh toán",
                      style: TextStyle(fontSize: 17.0)),
                  SizedBox(height: 15.0),
                  strBank == ""
                      ? new Text("Chọn trong danh sách",
                          style: TextStyle(fontSize: 17.0, color: Colors.grey))
                      : new Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: CanteenAppTheme.myGrey,
                                      width: 0.5))),
                          child: new Row(
                            children: <Widget>[
                              new Image.network(
                                strBank,
                                width: 50,
                                height: 40,
                              ),
                              SizedBox(width: 20),
                              new Text(bankSelect.cardNumber.substring(0, 4) + " **** **** ****"),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: new GestureDetector(
                    onTap: () {
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
                              color: strBank == "" ||
                                      _textFieldController.text == ""
                                  ? Colors.grey
                                  : const Color.fromRGBO(229, 32, 32, 1.0),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(5.0))),
                          child: new Text("NẠP TIỀN",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ))),
                    ),
                  ),
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