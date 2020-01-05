import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:uit_cantin/pages/HomeMain.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/History.dart';
import 'package:uit_cantin/pages/User.dart';
import 'package:uit_cantin/models/CardGet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/pages/Login.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  UserInfo userInfo = new UserInfo();
  int _currentIndex = 0;

  List<BottomNavigationBarItem> list1 = [
    new BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Trang chủ'),
    ),
    new BottomNavigationBarItem(
      icon: Icon(Icons.add_shopping_cart),
      title: Text('Đơn hàng'),
    ),
    new BottomNavigationBarItem(
        icon: Icon(Icons.history),
        title: Text('Hoạt động')
    ),
    new BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle),
        title: Text('Người dùng')
    )
  ];

  List<BottomNavigationBarItem> list2 = [
    new BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Trang chủ'),
    ),
    new BottomNavigationBarItem(
      icon: Icon(Icons.add_shopping_cart),
      title: Text('Đơn hàng'),
    ),
    new BottomNavigationBarItem(
      icon: Icon(Icons.subdirectory_arrow_right),
      title: Text('Đăng xuất'),
    ),
  ];


  final List<Widget> _children = [
    HomeMainScreen(),
    OrderScreen(),
    HistoryScreen(),
    UserScreen()
  ];

  List<CardGet> listCard;
  int lengthCard = 0;

  @override
  void initState() {
    _fetchUserInfo().then((data) => setState(() {
      setState(() {
        userInfo = data;
      });
    }));
    super.initState();
  }

  void _logout() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Bạn có muốn thoát khỏi tài khoản?"),
            //   content: new Text("Call 0352107018"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Có"),
                onPressed: () async {
                  Token token = new Token();
                  await token.removeMobileToken();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      SlideFromLeftPageRoute(
                          widget: LoginScreen()
                      )
                  );
                },
              ),
              new FlatButton(
                child: new Text("Không"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  void onTabTapped(int index) {
      if (index == 2 && userInfo.userGroupId == GROUP_REP) {
        _logout();
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: userInfo.userId != null ? new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.white,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Color.fromRGBO(229, 32, 32, 1.0),
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.grey))),
            // sets the inactive color of the `BottomNavigationBar`
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped, // new
              currentIndex: _currentIndex, // new
              items: userInfo.userGroupId == 4 ? list2 : list1,
            )
        ) : null
    );
  }
}
