import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Payment.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/pages/OrderSuccess.dart';
import 'package:uit_cantin/services/FormatPrice.dart';

import 'package:uit_cantin/models/CheckOut.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:uit_cantin/models/DeliveryPlace.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

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

  CheckOut checkOutInfo = new CheckOut();

  @override
  void initState() {
    _fetchUserInfo().then((data) => setState(() {
          setState(() {
            UserInfo userInfo = data;
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

  _checkout() async {

    var url = '$SERVER_NAME/order/check-out';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var response =
        await http.post(url, body: checkOutInfo.toMap(), headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
    //  isLoading = false;
      var status = responseBody["status"];
      print(status);
      if (status == STATUS_SUCCESS) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderSuccessScreen()));
      } else {
    //    _showDialogSuccess();
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
      appBar: AppBar(
        title: Text("Xác nhận đơn hàng"),
        backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tổng cộng",
                style: Theme.of(context).textTheme.title,
              ),
              Text(FormatPrice.getFormatPrice(widget.totalOrder.toString()),
                  style: Theme.of(context).textTheme.title),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Phương thức thanh toán".toUpperCase())),
          Container(
              width: double.infinity,
              child: listMethod != null ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: listMethod.length,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, position) {
                    return RadioListTile(
                      groupValue: true,
                      value:
                      listMethod[position].methodId.toString() == checkOutInfo.methodId
                          ? true
                          : false,
                      title: Text(listMethod[position].methodName),
                      onChanged: (value) {
                        setState(() {
                          checkOutInfo.methodId= listMethod[position].methodId.toString();
                        });
                      },
                    );
                  }): new Container()),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Vị trí".toUpperCase())),
          Container(
              width: double.infinity,
              child: listPlace != null ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: listPlace.length,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, position) {
                    return RadioListTile(
                      groupValue: true,
                      value: listPlace[position].placeId.toString() == checkOutInfo.deliveryPlaceId
                          ? true
                          : false,
                      title: Text(listPlace[position].placeName),

                      onChanged:
                      listPlace[position].placeId == 2 && role == 1
                          ? null
                          : (val) {
                        setState(() {
                          checkOutInfo.deliveryPlaceId =
                              listPlace[position].placeId.toString();
                          checkOutInfo.deliveryValue = "";
                        });
                      },
                    );
                  }): new Container()),
          checkOutInfo.deliveryPlaceId == "1" ?
          Container(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                  new Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 40.0,
                      width: 40.0,
                      child: FittedBox(
                        child: FloatingActionButton.extended(
                          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
                          icon: Icon(Icons.camera_alt),
                          label: Text("Quét"),
                          onPressed: _scanQR,
                        ),
                      ),
                    ),
                  )
                ],
              )) :
          Container(
              padding: EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: new Text("Nhập nơi giao: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  new Expanded(
                    flex: 2,
                    child: new Container(
                      child: new TextField(
                          autofocus: false,
                          decoration: const InputDecoration(
                            hintText: 'Ví dụ: Phòng E.4',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                          onChanged: (String value) {
                            setState(() {
                              checkOutInfo.deliveryValue = value;
                            });
                          }),
                    ),
                  ),
                ],
              )),
          Container(
            width: double.infinity,
            height: 50.0,
            margin:
                EdgeInsets.only(top: 50),
            child: RaisedButton(
              color: checkOutInfo.deliveryValue != null && checkOutInfo.deliveryValue != "" ? Color.fromRGBO(229, 32, 32, 1.0) : Colors.grey,
              onPressed: _checkout,
              child: Text(
                "Xác nhận".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
