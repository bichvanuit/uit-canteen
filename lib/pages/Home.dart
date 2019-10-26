import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/HomeMain.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/User.dart';
import 'package:uit_cantin/pages/Notification.dart';
import 'package:uit_cantin/compoments/BottomBarView.dart';
import 'package:uit_cantin/models/TabIconData.dart';
import 'package:uit_cantin/pages/Wallet.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:extended_navbar_scaffold/extended_navbar_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int bottomSelectedIndex = 0;

  AnimationController animationController;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home), title: new Text('Trang chủ')),
      BottomNavigationBarItem(
        icon: new Icon(Icons.notifications),
        title: new Text('Thông báo'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.payment),
        title: new Text('Liên kết'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle), title: Text('Người dùng'))
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomeMainScreen(),
        NotificationScreen(),
        OrderScreen(),
        WalletScreen(),
        UserScreen(),
      ],
    );
  }

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //  tabBody =
                  //      MyDiaryScreen(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //  tabBody =
                  //      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }

  final parallaxCardItemsList = <ParallaxCardItem>[
    ParallaxCardItem(
        title: 'Some Random Route 1',
        body: 'Place 1',
        background: Container(
          color: Colors.orange,
        )),
    ParallaxCardItem(
        title: 'Some Random Route 2',
        body: 'Place 2',
        background: Container(
          color: Colors.redAccent,
        )),
    ParallaxCardItem(
        title: 'Some Random Route 3',
        body: 'Place 1',
        background: Container(
          color: Colors.blue,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeMainScreen(),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingActionButton(
//          onPressed: null,
//          backgroundColor: CanteenAppTheme.main,
//          child: const Icon(
//            Icons.add_shopping_cart,
//            color: Colors.white,
//          )),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeMainScreen()));
                });
              }
          ),
          SpeedDialChild(
              child: Icon(Icons.notifications),
              backgroundColor: Colors.amber,
              label: 'Thông báo',
              //        labelStyle: TextTheme(fontSize: 18.0),
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NotificationScreen()));
                });
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.add_shopping_cart),
            backgroundColor: Colors.blue,
            label: 'Đơn hàng',
       //     labelStyle: TextTheme(fontSize: 18.0),
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderScreen()));
                });
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.supervised_user_circle),
            backgroundColor: Colors.green,
            label: 'Người dùng',
            //      labelStyle: TextTheme(fontSize: 18.0),
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserScreen()));
                });
              }
          ),
        ],
      ),
//      bottomNavigationBar: BottomAppBar(
//          shape: CircularNotchedRectangle(),
//          notchMargin: 4.0,
//          child: new Container(
//            height: 50.0,
//            child: new Row(
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                IconButton(icon: Icon(Icons.home),),
//                IconButton(icon: Icon(Icons.search))
//              ],
//            ),
//          )),

//        bottomNavigationBar: new Theme(
//            data: Theme.of(context).copyWith(
//              // sets the background color of the `BottomNavigationBar`
//                canvasColor: Colors.white,
//                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
//                primaryColor: Color.fromRGBO(229, 32, 32, 1.0),
//                textTheme: Theme
//                    .of(context)
//                    .textTheme
//                    .copyWith(caption: new TextStyle(color: Colors.grey))), // sets the inactive color of the `BottomNavigationBar`
//            child: BottomNavigationBar(
//              type: BottomNavigationBarType.fixed,
//              currentIndex: bottomSelectedIndex,
//              onTap: (index) {
//                bottomTapped(index);
//              },
//              items: buildBottomNavBarItems(),
//            )
//        )
    );
  }
}
