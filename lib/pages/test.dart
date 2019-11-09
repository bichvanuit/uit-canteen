import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/HomeMain.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/User.dart';
import 'package:uit_cantin/pages/Notification.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Trang chủ')
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.notifications),
        title: new Text('Thông báo'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.add_shopping_cart),
        title: new Text('Đơn hàng'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          title: Text('Người dùng')
      )
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
        UserScreen(),
      ],
    );
  }

  @override
  void initState() {
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
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Color.fromRGBO(229, 32, 32, 1.0),
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.grey))), // sets the inactive color of the `BottomNavigationBar`
          child: BottomNavigationBar(
            currentIndex: bottomSelectedIndex,
            onTap: (index) {
              bottomTapped(index);
            },
            items: buildBottomNavBarItems(),
          ),)
    );
  }
}