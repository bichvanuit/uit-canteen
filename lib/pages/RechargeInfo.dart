import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

class RechargeInfoScreen extends StatefulWidget {
  @override
  _RechargeInfoState createState() => _RechargeInfoState();
}

class _RechargeInfoState extends State<RechargeInfoScreen> {
  TextEditingController _textFieldController = TextEditingController();

  List<Color> listColor = [Color(0xFFA9F5F2), Color(0xFFA9F5F2), Color(0xFFA9F5F2)];

  _onPress(String value) {
    List<Color> listColor = [Colors.white, Colors.white, Colors.white];
    setState(() {
      _textFieldController.text = value;
      switch (value) {
        case "10000":
          listColor[0] = Color(0xFFA9F5F2);
          break;
        case "50000":
          listColor[1] = Color(0xFFA9F5F2);
          break;
        case "100000":
          listColor[2] = Color(0xFFA9F5F2);
          break;
        default: break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: CanteenAppTheme.main,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text("Nạp tiền"),
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFE6E6E6),
        child: new Column(
          children: <Widget>[
            new Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  new Text(
                    "1. Chọn số tiền muốn nạp (VNĐ)",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  SizedBox(height: 15.0,),
                  new Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                _onPress("10000");
                              },
                              child: new Container(
                                alignment: Alignment.center,

                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: listColor[0],
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: new Text("10.000", style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                _onPress("50000");
                              },
                              child: new Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: listColor[1],
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: new Text("50.000", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            )),
                        new Expanded(
                            child: new GestureDetector(
                              onTap: () {
                                _onPress("100000");
                              },
                              child: new Container(

                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: listColor[2],
                                    border: Border.all(color: Colors.grey, width: 1.0)),
                                child: new Text("100.000", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ))
                      ],
                    ),
                  ),
                  new Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(color: Colors.white),
                      child: new TextField(
                          controller: _textFieldController,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          decoration: const InputDecoration(
                            hintText: 'Ví dụ: 10000',
                            hintStyle:
                            const TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                         )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("2. Chọn phương thức thanh toán", style: TextStyle(fontSize: 17.0)),
                  SizedBox(height: 15.0),
                  new Text("Chọn trong danh sách", style: TextStyle(fontSize: 17.0, color: Colors.grey))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
