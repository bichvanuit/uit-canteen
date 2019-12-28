import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/User.dart';
import 'package:uit_cantin/models/TabIconData.dart';
import 'package:uit_cantin/pages/Wallet.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:uit_cantin/pages/History.dart';
import 'package:uit_cantin/compoments/SpecialOffer.dart';
import 'package:uit_cantin/compoments/TodayOrder.dart';
import 'package:uit_cantin/compoments/AdvertisementWall.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:flutter/foundation.dart';
import 'package:uit_cantin/pages/DeliveryMethod.dart';
import 'package:uit_cantin/compoments/StopServingWidget.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int bottomSelectedIndex = 0;
  AnimationController animationController;

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
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => new DeliveryMethodScreen(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 2000),
                    ),
                  );
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

  @override
  void initState() {
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
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
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
              body: SingleChildScrollView(
                  child: Container(
                      child: new Column(
                children: <Widget>[
                  new Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => new WalletScreen(),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 2000),
                            ),
                          );
                        });
                      },
                      child: AdvertisementWall(),
                    ),
                  ),
                  new Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: new StopServingWidget()),
                  new Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: new SpecialOffer()),
                  new Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: new TodayOffer())
                ],
              )))),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: CanteenAppTheme.main,
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.home),
                  backgroundColor: Colors.red,
                  label: 'Trang chủ',
                  //        labelStyle: TextTheme(fontSize: 18.0),
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => new HomeScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 2000),
                        ),
                      );
                    });
                  }),
              SpeedDialChild(
                  child: Icon(Icons.add_shopping_cart),
                  backgroundColor: Colors.amber,
                  label: 'Đơn hàng',
                  //     labelStyle: TextTheme(fontSize: 18.0),
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => new OrderScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 2000),
                        ),
                      );
                    });
                  }),
              SpeedDialChild(
                  child: Icon(Icons.history),
                  backgroundColor: Colors.blue,
                  label: 'Hoạt động',
                  //     labelStyle: TextTheme(fontSize: 18.0),
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => new HistoryScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 2000),
                        ),
                      );
                    });
                  }),
              SpeedDialChild(
                  child: Icon(Icons.supervised_user_circle),
                  backgroundColor: Colors.green,
                  label: 'Người dùng',
                  //      labelStyle: TextTheme(fontSize: 18.0),
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => new UserScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 2000),
                        ),
                      );
                    });
                  }),
            ],
          ),
        ));
  }
}
