import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/pages/InfoBank.dart';

class BankScreen extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<BankScreen> {
  bool _value1 = false;

  List<String> listVisa = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Visa.svg/1200px-Visa.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Mastercard_2019_logo.svg/1200px-Mastercard_2019_logo.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/JCB_logo.svg/1200px-JCB_logo.svg.png",

  ];

  List<String> listBank = [
    "https://blog.topcv.vn/wp-content/uploads/2018/03/l%C3%A0m-vi%E1%BB%87c-t%E1%BA%A1i-VietinBank-10.png",
    "http://file.vforum.vn/hinh/2015/11/chi-nhanh-vietcombank-hai-phong.jpg",
    "https://thebank.vn/static/6/1135/714/90/2019/06/12/thebank_thebank_bidv_1536317691min_1560304600.jpg",
    "https://hstatic.net/131/1000047131/10/2015/11-27/acb.jpg",
    "https://thebank.vn/static/6/1135/714/90/2019/07/03/thebank_phidichvuthesacombankmin_1562146814.png",
    "https://tbck.vn/stores/news_dataimages/thuhoai/082019/10/09/1445_agri.jpg",
    "http://www.bongthom.com/Clients/3199/images/mbbank1.png",
    "https://static.ybox.vn/2019/1/1/1548081192492-1547708804849-logo_moi.jpg",
    "https://i.ytimg.com/vi/qpbFDBjisag/maxresdefault.jpg"

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          //  title: appBarTitle,
          iconTheme: new IconThemeData(color: Colors.white),
          //  leading: _isSearching ? const BackButton() : null,
          title: Text("Chọn ngân hàng"),
        ),
        body: new Container(
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text("THẺ QUỐC TẾ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              new Text("Chỉ hổ trợ phát hành tại VIết Nam", style: TextStyle(fontSize: 16),),
              GridView.count(
                crossAxisCount: 3,
            //    childAspectRatio: (itemWidth / itemHeight),
                controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(4.0),
                children: listVisa.map((url) {
                  return new GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => InfoBankScreen()));
                      });
                    },
                    child: new Container(
                      margin: const EdgeInsets.all(5.0),
                      child: new Image.network(url),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 8.0),
              new Text("NGÂN HÀNG LIÊN KẾT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              GridView.count(
                crossAxisCount: 3,
                //    childAspectRatio: (itemWidth / itemHeight),
                controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(4.0),
                children: listBank.map((url) {
                  return new GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => InfoBankScreen()));
                      });
                    },
                    child: new Container(
                      margin: const EdgeInsets.all(5.0),
                      child: new Image.network(url),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
  }
}
