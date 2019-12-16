import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/pages/Bank.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<WalletScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
        //  title: appBarTitle,
        iconTheme: new IconThemeData(color: Colors.white),
        //  leading: _isSearching ? const BackButton() : null,
        title: Text("Liên kết"),
      ),
      body: new Container(
        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Xin chào Vân",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            new Text(
              "Thanh toán dễ dàng không dùng tiền mặt",
              style: TextStyle(color: Colors.grey, fontSize: 20.0),
            ),
            SizedBox(
              height: 20,
            ),
            new GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => new BankScreen(),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 2000),
                    ),
                  );
                });
              },
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                decoration: new BoxDecoration(
                    color: CanteenAppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: CanteenAppTheme.grey.withOpacity(0.2),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 5.0),
                    ]),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0) ,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                              BorderSide(color: CanteenAppTheme.myGrey, width: 0.5))),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Kích hoạt ví", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                SizedBox(height: 7.0),
                                new Text("Nạp tiền, thanh toán và nhiều tiện ích khác", style: TextStyle(fontSize: 18.0),),
                              ],
                            ),
                          ),
                          Container(
                              height: 50,
                              width: 50,
                              child: new Image.network(
                                  "http://www.global-yamato.com/business/service/online-payment/img/img_thumbnail_04.png"))
                        ],
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0) ,
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            "Kích hoạt",
                            style: TextStyle(
                                color: CanteenAppTheme.main,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: new Container(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
//        body: new Container(
//          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
//          child: new Column(
//            children: <Widget>[
//              new GestureDetector(
//                onTap: () {
//                  setState(() {
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => BankScreen()));
//                  });
//                },
//                child: new Container(
//                    decoration: BoxDecoration(color: CanteenAppTheme.main),
//                    padding: const EdgeInsets.fromLTRB(0, 10.0, 10.0, 10.0),
//                    child: new Row(
//                      children: <Widget>[
//                        new Expanded(
//                          flex: 2,
//                          child: new Container(
//                            child: new Icon(
//                              Icons.payment,
//                              color: Colors.white,
//                              size: 50,
//                            ),
//                          ),
//                        ),
//                        new Expanded(
//                            flex: 5,
//                            child: new Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                new Text(
//                                  "Thêm liên kết",
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontSize: 20,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                                SizedBox(height: 5),
//                                new Text(
//                                  "Thêm thẻ tín dụng, thẻ ghi nợ hoặc tài khoản ngân hàng",
//                                  style: TextStyle(color: Colors.white),
//                                )
//                              ],
//                            )),
//                        new Expanded(
//                          flex: 1,
//                          child: new Container(
//                            child: new Icon(
//                              Icons.keyboard_arrow_right,
//                              color: Colors.white,
//                              size: 30,
//                            ),
//                          ),
//                        )
//                      ],
//                    )),
//              ) ,
//              new Container(
//                margin: const EdgeInsets.only(top: 10),
//                alignment: Alignment.topLeft,
//                child: new Text("ĐÃ LIÊN KẾT (1)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
//              ),
//              new Container(
//                margin: const EdgeInsets.only(top: 10),
//                width: MediaQuery.of(context).size.width,
//                child: Image.network("https://img.123pay.vn/imgnew123payvn/images/123be/TheMaritime.jpg", fit: BoxFit.cover,),
//              ),
//            ],
//          ),
//        )
    );
  }
}
