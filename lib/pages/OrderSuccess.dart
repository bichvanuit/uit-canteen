import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/Home.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  _OrderSuccess createState() => _OrderSuccess();
}

class _OrderSuccess extends State<OrderSuccessScreen> {

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Quay về trang chủ'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Hủy'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => new HomeScreen(),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 2000),
                ),
              );
            },
            child: new Text('Tiếp tực'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: new Container(
              padding: new EdgeInsets.all(25.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    height: 200.0,
                    width: 200.0,
                    child: new Image.asset('assets/order-success.png'),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: new Center(
                      child: new Text(
                        "Đặt món thành công",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: new Center(
                      child: new Text(
                        "Xin bạn chờ trong giây lát",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                  ),
                  new GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                      });
                    },
                    child: new Container(
                      margin: const EdgeInsets.only(top: 20.0),
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
                          child: new Text("Quay về trang chủ",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ))),
                    ),
                  ),
                ],
              ))),
    );
  }
}
