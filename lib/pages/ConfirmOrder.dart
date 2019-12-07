import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Payment.dart';
import 'dart:async';
import 'package:uit_cantin/canteenAppTheme.dart';

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
import 'package:uit_cantin/pages/DeliveryMethod.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  String result = "***";
  int role;
  List<PaymentMethod> listMethod;
  List<DeliveryPlace> listPlace;
  bool isLoading;
  UserInfo userInfo = new UserInfo();
  String paymentMethod = "";
  String timeRemaining = "";
  bool isWaiting = true;

  int locationId = 1;

  DateTime date3 = DateTime.now();

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
          paymentMethod = listMethod[0].methodId.toString();
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

  _waitingProcess() async {
    Token token = new Token();
    await token.setMobileWaiting(timeRemaining);
    setState(() {
      isLoading = false;
      Navigator.of(context).pop();
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }

  _checkout() async {
    var url = '$SERVER_NAME/order/check-out';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["payment_method_id"] = paymentMethod;

    if (timeRemaining == "0") {
      DateTime date = DateTime.now();
      isWaiting = false;
      timeRemaining = date.hour.toString() + ":" + date.minute.toString() + ":" + date.second.toString();
    } else {
      isWaiting = true;
    }
    requestBody["time_remaining"] = timeRemaining;

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
        if (isWaiting) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialog(
                  alertTitle: richTitle("Đặt đơn thành công"),
                  alertSubtitle: richSubtitle(
                      "Hẹn gặp lại bạn vào " + timeRemaining + " nhé!!!"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () {
                        _waitingProcess();
                      },
                      child: new Container(
                          width: 100.0,
                          height: 35.0,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                              color: Color.fromRGBO(229, 32, 32, 1.0),
                              borderRadius:
                              new BorderRadius.all(const Radius.circular(5.0))),
                          child: new Text("OK",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ))),
                    )
                  ],
                );
              });

        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DeliveryMethodScreen()));
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              createDialog(responseBody["message"]),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userInfo.fullName == null
          ? fullAppbar(context, "bạn", widget.totalOrder.toString())
          : fullAppbar(
              context, userInfo.fullName, widget.totalOrder.toString()),
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
                          child: RadioListTile(
                            groupValue: true,
                            value: listMethod[position].methodId.toString() ==
                                    paymentMethod
                                ? true
                                : false,
                            title: Text(listMethod[position].methodName),
                            onChanged: (value) {
                              setState(() {
                                var id = listMethod[position].methodId.toString();
                                if (id != "1") {
                                  locationId = 1;
                                }
                                paymentMethod =
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
              'Bạn có muốn được phục vụ ngay không?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: new Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: true,
                  value: locationId == 1 ? true : false,
                  title: Text("Có"),
                  onChanged: (value) {
                    setState(() {
                      timeRemaining = "0";
                      locationId = 1;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                )
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
                  value: locationId == 2 ? true : false,
                  title: Text("Không, hay đợi tôi đến "),
//                  onChanged: (value) {
//                    setState(() {
//                      locationId = 2;
//                      timeRemaining = date3.hour.toString() +
//                          ":" +
//                          date3.minute.toString() +
//                          ":" +
//                          date3.second.toString();
//                      // checkOutInfo.methodId= listMethod[position].methodId.toString();
//                    });
//                  },
                  onChanged: paymentMethod != "1"
                      ? null
                      : (val) {
                          setState(() {
                            locationId = 2;
                            timeRemaining = date3.hour.toString() +
                                ":" +
                                date3.minute.toString() +
                                ":" +
                                date3.second.toString();
                          });
                        },
                ),
                paymentMethod != "1" && paymentMethod != "" ? new Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: new Text(
                    "Vì bạn đã chọn thanh toán bằng tiền mặt nên không được dùng tính năng này",
                    style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                  ),
                ) : new Container(),
                FlatButton(
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          timeRemaining = date3.hour.toString() +
                              ":" +
                              date3.minute.toString() +
                              ":" +
                              date3.second.toString();
                          date3 = date;
                        });
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
                      color: Color.fromRGBO(229, 32, 32, 1.0),
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
