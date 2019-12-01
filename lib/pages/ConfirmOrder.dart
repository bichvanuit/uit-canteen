import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Payment.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/pages/OrderSuccess.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

import 'package:uit_cantin/models/CheckOut.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:uit_cantin/models/DeliveryPlace.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/compoments/CustomDialog.dart';
import 'package:uit_cantin/pages/Recharge.dart';
import 'package:uit_cantin/pages/Wallet.dart';
import 'package:uit_cantin/pages/test.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

List<PaymentMethod> _parseMethod(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed
      .map<PaymentMethod>((json) => PaymentMethod.fromJson(json))
      .toList();
}

Future<List<PaymentMethod>> _fetchMethod() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/common/get-payment-methods',
      headers: requestHeaders);
  return _parseMethod(response.body);
}

List<DeliveryPlace> _parsePlace(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed
      .map<DeliveryPlace>((json) => DeliveryPlace.fromJson(json))
      .toList();
}

Future<List<DeliveryPlace>> _fetchPlace() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get(
      '$SERVER_NAME/common/get-delivery-place-types',
      headers: requestHeaders);
  return _parsePlace(response.body);
}

Future<UserInfo> _fetchUserInfo() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/user/get-detail-user',
      headers: requestHeaders);
  final parsed = json.decode(response.body)["data"];
  return UserInfo.fromJson(parsed);
}

class ConfirmOrderScreen extends StatefulWidget {
  final double totalOrder;

  ConfirmOrderScreen({Key key, this.totalOrder}) : super(key: key);

  @override
  _ConfirmOrder createState() => _ConfirmOrder();
}

class _ConfirmOrder extends State<ConfirmOrderScreen> {
  int paymentId = 1;
  String result = "Quét mã";
  int role;
  List<PaymentMethod> listMethod;
  List<DeliveryPlace> listPlace;
  bool isLoading;
  UserInfo userInfo = new UserInfo();

  DateTime date3 = DateTime.now();

  CheckOut checkOutInfo = new CheckOut();

  @override
  void initState() {
    isLoading = false;

    _fetchUserInfo().then((data) => setState(() {
          setState(() {
            userInfo = data;
            role = userInfo.userGroupId;
          });
        }));
    _fetchMethod().then((data) => setState(() {
          listMethod = data;
          checkOutInfo.methodId = listMethod[0].methodId.toString();
        }));

    _fetchPlace().then((data) => setState(() {
          listPlace = data;
          checkOutInfo.deliveryPlaceId = listPlace[0].placeId.toString();
        }));

    super.initState();
  }

  Widget createDialog(String message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, message),
    );
  }

  dialogContent(BuildContext context, String message) {
    bool isActived = true;
    if (message.contains("Ví chưa được kích hoạt")) {
      isActived = false;
    }
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
            children: <Widget>[
              Text(
                "Thông báo lỗi",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              new GestureDetector(
                onTap: () {
                  if (isActived) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RechargeScreen()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletScreen()));
                  }
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
                      child: new Text(
                          isActived == true
                              ? "Nạp tiền ngay"
                              : "Kích hoạt ngay",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ))),
                ),
              ),
              SizedBox(height: 10),
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
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(5.0)),
                          border: Border.all(color: Colors.grey, width: 2.0)),
                      child: new Text("Đổi phương thức thanh toán",
                          style: new TextStyle(
                            color: Colors.grey,
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

  _checkout() async {
    var url = '$SERVER_NAME/order/check-out';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var response = await http.post(url,
        body: checkOutInfo.toMap(), headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderSuccessScreen()));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              createDialog(responseBody["message"]),
        );
      }
    }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        checkOutInfo.deliveryValue = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          fullAppbar(context, userInfo.fullName, widget.totalOrder.toString()),
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Widget _createBody() {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text(
              'Phương thức thanh toán',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),

          Container(
              width: double.infinity,
              child: listMethod != null
                  ? new ListView.builder(
                      shrinkWrap: true,
                      itemCount: listMethod.length,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, position) {
                        return Container(
                          margin: EdgeInsets.only(top: 5),
                          //    padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
                          child: RadioListTile(
                            groupValue: true,
                            value: listMethod[position].methodId.toString() ==
                                    checkOutInfo.methodId
                                ? true
                                : false,
                            title: Text(listMethod[position].methodName),
                            onChanged: (value) {
                              setState(() {
                                checkOutInfo.methodId =
                                    listMethod[position].methodId.toString();
                              });
                            },
                          ),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: [0.015, 0.015],
                                colors: [CanteenAppTheme.main, Colors.white],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color:
                                        CanteenAppTheme.grey.withOpacity(0.2),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 5.0),
                              ]),
                        );
                      })
                  : new Container()),
          Container(
            margin: EdgeInsets.only(bottom: 15, top: 15),
            child: Text(
              'Bạn có đang ở căn tin',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 5),
            //    padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
            child: new Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: true,
                  value: true,
                  title: Text("Có, tôi đang ở bàn số ***"),
                  onChanged: (value) {
                    setState(() {
                      // checkOutInfo.methodId= listMethod[position].methodId.toString();
                    });
                  },
                ),
                Container(
                  alignment: Alignment.centerRight,
                  height: 50.0,
                  width: 70.0,
                  child: FittedBox(
                    child: FloatingActionButton.extended(
                      backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
                      icon: Icon(Icons.camera_alt),
                      label: Text("Quét mã QR"),
                      onPressed: _scanQR,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
                  colors: [CanteenAppTheme.main, Colors.white],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: CanteenAppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 5.0),
                ]),
          ),

          Container(
            margin: EdgeInsets.only(top: 5),
            //    padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
            child: new Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: true,
                  value: false,
                  title: Text("Không, tôi sẽ xuống căn tin vào lúc"),
                  onChanged: (value) {
                    setState(() {
                      // checkOutInfo.methodId= listMethod[position].methodId.toString();
                    });
                  },
                ),
                FlatButton(
                    onPressed: () {
                      DatePicker.showTimePicker(context, showTitleActions: true,
                          onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          date3 = date;
                        });
                        print('confirm $date');
                      }, currentTime: date3, locale: LocaleType.vi);
                    },
                    child: Text(
                      date3.hour.toString() + ":" + date3.minute.toString(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
                  colors: [CanteenAppTheme.main, Colors.white],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: CanteenAppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 5.0),
                ]),
          ),

//          Container(
//              width: double.infinity,
//              child: listPlace != null ? new ListView.builder(
//                  shrinkWrap: true,
//                  itemCount: listPlace.length,
//                  scrollDirection: Axis.vertical,
//                  physics: BouncingScrollPhysics(),
//                  itemBuilder: (context, position) {
//                    return RadioListTile(
//                      groupValue: true,
//                      value: listPlace[position].placeId.toString() == checkOutInfo.deliveryPlaceId
//                          ? true
//                          : false,
//                      title: Text(listPlace[position].placeName),
//
//                      onChanged:
//                      listPlace[position].placeId == 2 && role == 1
//                          ? null
//                          : (val) {
//                        setState(() {
//                          checkOutInfo.deliveryPlaceId =
//                              listPlace[position].placeId.toString();
//                          checkOutInfo.deliveryValue = "";
//                        });
//                      },
//                    );
//                  }): new Container()),
//          checkOutInfo.deliveryPlaceId == "1" ?
//          Container(
//              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
//              child: new Row(
//                children: <Widget>[
//                  new Expanded(
//                    child: new Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
//                  ),
//                  new Expanded(
//                    child: Container(
//                      alignment: Alignment.centerRight,
//                      height: 40.0,
//                      width: 40.0,
//                      child: FittedBox(
//                        child: FloatingActionButton.extended(
//                          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
//                          icon: Icon(Icons.camera_alt),
//                          label: Text("Quét"),
//                          onPressed: _scanQR,
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//              )) :
//          Container(
//              padding: EdgeInsets.all(8.0),
//              child: new Row(
//                children: <Widget>[
//                  new Expanded(
//                    flex: 1,
//                    child: new Text("Nhập nơi giao: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                  ),
//                  new Expanded(
//                    flex: 2,
//                    child: new Container(
//                      child: new TextField(
//                          autofocus: false,
//                          decoration: const InputDecoration(
//                            hintText: 'Ví dụ: Phòng E.4',
//                            hintStyle: const TextStyle(color: Colors.grey),
//                          ),
//                          style: const TextStyle(
//                              color: Colors.black, fontSize: 16.0),
//                          onChanged: (String value) {
//                            setState(() {
//                              checkOutInfo.deliveryValue = value;
//                            });
//                          }),
//                    ),
//                  ),
//                ],
//              )),
          new GestureDetector(
            onTap: () {
              setState(() {
                isLoading = true;
                _checkout();
              });
            },
            child: new Container(
              margin: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: new Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45.0,
                  alignment: FractionalOffset.center,
                  decoration: new BoxDecoration(
                      color: checkOutInfo.deliveryValue != null &&
                              checkOutInfo.deliveryValue != ""
                          ? Color.fromRGBO(229, 32, 32, 1.0)
                          : Colors.grey,
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
