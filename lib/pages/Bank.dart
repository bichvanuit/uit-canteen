import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/ConfirmTeleNumber.dart';

class BankScreen extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<BankScreen> {
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
        body: SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: new Column(
              children: <Widget>[
                new Text(
                  "Các ngân hàng đã hổ trợ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                new Container(
                  child: new Image.network(
                      "https://www.webico.vn/wp-content/uploads/2017/08/banknet-bank.png"),
                ),
                SizedBox(height: 20.0),
                new Text(
                  "Kích hoạt thành công bạn có thể",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                new Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Row(
                          children: <Widget>[
                            Image.network(
                              "https://cdn5.vectorstock.com/i/1000x1000/33/44/money-transaction-icon-vector-21023344.jpg",
                              width: 30,
                              height: 30,
                            ),
                            Text(
                              "Sử dụng số dư",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Row(
                          children: <Widget>[
                            Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSMoS4gf_odiCXmG9iWyysSrorFtKhX4r1sdUsAjugz3u6geAwo",
                              width: 30,
                              height: 30,
                            ),
                            Text("Giao dịch an toàn",
                                style: TextStyle(fontSize: 17))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                new GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ConfirmTeleNumnerScreen()));
                    });
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
                        child: new Text("Tiếp tục",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ))),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Color(0xFFF8E0E6),
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        "Bạn có thể dùng những loại thẻ sau để liên kết",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 3.0),
                      new Text(
                          "- Thẻ ATM được phát hành bởi các ngân hàng hợp tác với Moca", style: TextStyle(fontSize: 16)),
                      new Text(
                          "- Thẻ ghi nợ quốc tế (Visa / MasterCard / JCB / Amex) được phát hành bởi ngân hàng MSB, SCB, SHB hoặc VietCombank.", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 3.0),
                      new Text(
                          "Xin lưu ý, theo quy định của Ngân hàng Nhà nước Việt Nam, bạn không thể sử dụng thẻ tín dụng để liên kết với ví điện tử",
                          style: TextStyle(fontSize: 16))
                    ],
                  ),
                )
//              GridView.count(
//                crossAxisCount: 3,
//                //    childAspectRatio: (itemWidth / itemHeight),
//                controller: new ScrollController(keepScrollOffset: false),
//                shrinkWrap: true,
//                scrollDirection: Axis.vertical,
//                padding: const EdgeInsets.all(4.0),
//                children: listBank.map((url) {
//                  return new GestureDetector(
//                    onTap: () {
//                      setState(() {
//                        .push(context,
//                            MaterialPageRoute(builder: (context) => InfoBankScreen()));
//                      });
//                    },
//                    child: new Container(
//                      margin: const EdgeInsets.all(5.0),
//                      child: new Image.network(url),
//                    ),
//                  );
//                }).toList(),
//              ),
              ],
            ),
          ),
        ));
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 5.0,
      width: 5.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
