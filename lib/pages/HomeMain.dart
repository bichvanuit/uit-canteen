import 'package:flutter/material.dart';
import 'package:uit_cantin/models/TabIconData.dart';
import 'package:uit_cantin/compoments/SpecialOffer.dart';
import 'package:uit_cantin/compoments/TodayOrder.dart';
import 'package:uit_cantin/compoments/AdvertisementWall.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/pages/DeliveryMethod.dart';
import 'package:uit_cantin/compoments/StopServingWidget.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/models/CardGet.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/pages/Bank.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';
import 'package:uit_cantin/models/UserInfo.dart';

List<CardGet> _parseCard(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<CardGet>((json) => CardGet.fromJson(json)).toList();
}

Future<List<CardGet>> _fetchCard() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/order/get-processing-order',
      headers: requestHeaders);
  return _parseCard(response.body);
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

class HomeMainScreen extends StatefulWidget {
  @override
  _HomeMainState createState() => new _HomeMainState();
}

class _HomeMainState extends State<HomeMainScreen> {
  UserInfo userInfo = new UserInfo();
  List<CardGet> listCard;
  int lengthCard = 0;

  @override
  void initState() {
    _fetchUserInfo().then((data) => setState(() {
      setState(() {
        userInfo = data;
      });
    }));

    _fetchCard().then((data) => setState(() {
          setState(() {
            listCard = data;
            lengthCard = listCard.length;
          });
        }));
    Token token = new Token();

    token.getMobileWaiting().then((value) {
      if (value != '') {
        showDialog(
          context: context,
          builder: (BuildContext context) => createDialog(),
        );
      }
    });

    super.initState();
  }

  Widget createDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
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
            top: 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
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
            children: <Widget>[
              Text(
                "Thông báo",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Bạn có một đơn hàng đã thanh toán đang chờ",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      SlideFromLeftPageRoute(widget: DeliveryMethodScreen()));
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
                      child: new Text("Hoàn tất đơn hàng",
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
                      child: new Text("Chờ chút",
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

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Bạn có chắc chắn muốn thoát khỏi ứng dụng'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Không'),
              ),
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Thoát ứng dụng'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: new Scaffold(
              resizeToAvoidBottomPadding: false,
              body: userInfo.userId != null
                  ? SingleChildScrollView(
                      child: Container(
                          child: new Column(
                      children: <Widget>[
                        userInfo.userGroupId != GROUP_REP
                            ? new Container(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          SlideFromLeftPageRoute(
                                              widget: BankScreen()));
                                    });
                                  },
                                  child: AdvertisementWall(),
                                ),
                              )
                            : new Container(),
                        new Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: new StopServingWidget()),
                        userInfo.userGroupId != GROUP_REP
                            ? new Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: new SpecialOffer())
                            : new Container(),
                        new Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: new TodayOffer())
                      ],
                    )))
                  : new Container()),
          floatingActionButton: lengthCard > 0
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlideFromLeftPageRoute(
                            widget: DeliveryMethodScreen()
                        )
                    );
                  },
                  child: new Stack(
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(
                          Icons.shopping_basket,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: null,
                      ),
                      new Positioned(
                          top: 20.0,
                          left: 14.0,
                          child: new Stack(
                            children: <Widget>[
                              new Icon(Icons.brightness_1,
                                  size: 20.0, color: CanteenAppTheme.main),
                              new Positioned(
                                  top: 3.0,
                                  left: 7.0,
                                  child: new Center(
                                    child: new Text(
                                      lengthCard.toString(),
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ],
                          )),
                    ],
                  ),
                  backgroundColor: CanteenAppTheme.main,
                )
              : null,
        ));
  }
}
