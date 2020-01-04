import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:uit_cantin/pages/HomeMain.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/History.dart';
import 'package:uit_cantin/pages/User.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeMainScreen(),
    OrderScreen(),
    HistoryScreen(),
    UserScreen()
  ];

  @override
  void initState() {
    super.initState();
  }


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        body: _children[_currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {

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
                              "5",
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
        ),
        bottomNavigationBar: new Theme(
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
          items: [
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
          ],
        )
    ),);
  }
}
