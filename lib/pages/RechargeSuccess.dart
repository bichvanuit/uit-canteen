import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/pages/Home.dart';

class RechargeSuccessScreen extends StatefulWidget {


  final String amount;
  final String method;
  RechargeSuccessScreen({Key key, this.amount, this.method}) : super(key: key);

  @override
  _RechargeSuccessState createState() => _RechargeSuccessState();
}


class _RechargeSuccessState extends State<RechargeSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            padding: new EdgeInsets.all(25.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                new Container(
                  height: 70,
                  width: 70,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle, color: CanteenAppTheme.main),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      "Nạp tiền thành công",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                new Text(
                  DateTime.now().toString(),
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 30.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: new Text(
                        "Thanh toán",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: new Text(
                        widget.amount + " VNĐ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 18.0),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: CanteenAppTheme.myGrey, width: 1.0))),
                ),
                SizedBox(height: 10.0),
                new Row(
                  children: <Widget>[
                    new Text(
                      "Phương thức thanh toán",
                      style: TextStyle(color: Colors.grey, fontSize: 18.0),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      widget.method,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: new GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => new HomeScreen(),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 2000),
                              ),
                            );
                          },
                          child: new Container(
                            margin: const EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.white),
                            child: new Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 45.0,
                                alignment: FractionalOffset.center,
                                decoration: new BoxDecoration(
                                    color: CanteenAppTheme.main,
                                    borderRadius: new BorderRadius.all(
                                        const Radius.circular(5.0))),
                                child: new Text("TIẾP TỤC MUA HÀNG",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ))),
                          ),
                        ),
                      )),
                )
              ],
            )));
  }
}
