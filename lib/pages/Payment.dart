import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Payment.dart';
class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethodScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<PaymentMethod> listMethod = <PaymentMethod>[
    new PaymentMethod(1, 'Tiền mặt',
        'https://benhviendongho.com/wp-content/uploads/2018/05/Tienmat_Icon_big-2-300x140.png'),
    new PaymentMethod(2, 'Zalopay',
        'https://img1.apk.tools/150/1/f/9/vn.com.vng.zalopay.png'),
    new PaymentMethod(3, 'Momo', 'https://static.mservice.io/img/logo-momo.png')
  ];

  int _currValue = 2;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Phương thức thanh toán")),
      body: new SingleChildScrollView(
          child: new Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: new Center(
                child: new Text(
                  "Chọn phương thức thanh toán",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            new Container(
              height: 500,
              child: new ListView.builder(
                  itemCount: listMethod.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, position) {
                    return new Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
                      padding: EdgeInsets.fromLTRB(3, 7, 3, 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: new Radio(
                              value: listMethod[position].methodId,
                              groupValue: _currValue,
                              onChanged: (int i) => setState(() {
                                _currValue = i;
                              }
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: new Center(
                              child: new Text(
                                listMethod[position].methodName,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new Container(
                              margin: const EdgeInsets.all(5.0),
                              width: MediaQuery.of(context).size.height * 0.1,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: new BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: new DecorationImage(
                                  image: new NetworkImage(
                                      listMethod[position].logo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.015, 0.015],
                          colors: [Color.fromRGBO(229, 32, 32, 1.0), Colors.white],
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(207, 207, 207, 1),
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }
}
