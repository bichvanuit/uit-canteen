import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Payment.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/pages/OrderSuccess.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:uit_cantin/models/DeliveryPlace.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/compoments/CustomDialog.dart';
import 'package:uit_cantin/pages/appBar/AppBarDelivery.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

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

class DeliveryMethodScreen extends StatefulWidget {

  DeliveryMethodScreen({Key key}) : super(key: key);

  @override
  _DeliveryMethod createState() => _DeliveryMethod();
}

class _DeliveryMethod extends State<DeliveryMethodScreen> {
  int paymentId = 1;
  String result = "***";
  int role;
  List<PaymentMethod> listMethod;
  List<DeliveryPlace> listPlace;
  bool isLoading;
  UserInfo userInfo = new UserInfo();

  String deliveryId = "";
  String deliveryValue = "";

  DateTime date3 = DateTime.now();

  @override
  void initState() {
    isLoading = false;

    _fetchUserInfo().then((data) => setState(() {
      setState(() {
        userInfo = data;
        role = userInfo.userGroupId;
        role = 2;
      });
    }));

    _fetchPlace().then((data) => setState(() {
      listPlace = data;
      deliveryId = listPlace[0].placeId.toString();
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
                message + ". Vui lòng thử lại",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              new GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
                      child: new Text("OK",
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
        ),
      ],
    );
  }

  _checkout() async {
    var url = '$SERVER_NAME/order/request-delivering';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["delivery_place_type_id"] = deliveryId;
    requestBody["delivery_place_value"] = deliveryValue;

    var response = await http.post(url,
        body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        await token.removeMobileWaiting();
        Navigator.push(
            context,
            SlideFromLeftPageRoute(
                widget: OrderSuccessScreen()
            )
        );
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
        deliveryValue = qrResult;
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
      appBar: userInfo.fullName == null ? fullAppbar(context, "bạn") :
      fullAppbar(context, userInfo.fullName),
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Widget _createBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text(
              'Phương thức nhận hàng',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
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
                      value: listPlace[position].placeId.toString() == deliveryId
                          ? true
                          : false,
                      title: Text(listPlace[position].placeName),

                      onChanged:
                      listPlace[position].placeId == 2 && role == 2
                          ? null
                          : (val) {
                        setState(() {
                          deliveryId =
                              listPlace[position].placeId.toString();
                          deliveryValue = "";
                        });
                      },
                    );
                  }): new Container()),
          deliveryId == "1" ?
          Container(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text("Bàn " + result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
                              deliveryValue = value;
                            });
                          }),
                    ),
                  ),
                ],
              )),
          new GestureDetector(
            onTap: () {
              setState(() {
                isLoading = true;
                _checkout();
              });
            },
            child: new Container(
              margin: EdgeInsets.only(top: 210),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: new Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45.0,
                  alignment: FractionalOffset.center,
                  decoration: new BoxDecoration(
                      color: deliveryValue != ""
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
