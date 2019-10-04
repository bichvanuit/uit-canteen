import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:uit_cantin/compoments/SpecialOffer.dart';
import 'package:uit_cantin/pages/Category.dart';
import 'package:uit_cantin/compoments/TodayOrder.dart';
import 'package:uit_cantin/test.dart';


class HomeMainScreen extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<HomeMainScreen> {

  BorderRadius borderRadius = new BorderRadius.only(
      bottomLeft: const Radius.circular(150.0));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
              child: new Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new Container(
                          height: 250.0,
                          child: Carousel(
                            images: [
                              NetworkImage("https://agiadinh.net/wp-content/uploads/2018/05/cach-lam-com-ga-xoi-mo-4-600x362.jpg"),
                              NetworkImage("https://beptruong.edu.vn/wp-content/uploads/2018/06/cach-uop-thit-nuong-com-tam.jpg"),
                              NetworkImage("https://cdn.eva.vn/upload/4-2018/images/2018-11-10/cach-lam-ga-kho-sa-ot-2-mien-thit-ga2-1541826930-53-width600height563.jpg"),
                              NetworkImage("https://agiadinh.net/wp-content/uploads/2016/05/cach-nau-canh-chua-ca-loc-600x441.jpg")
                            ],
                            showIndicator: false,
                            borderRadius: false,
                            moveIndicatorFromBottom: 180.0,
                            noRadiusForIndicator: true,
                            overlayShadow: true,
                            overlayShadowColors: Colors.white,
                            overlayShadowSize: 0.7,
                          )
                      ),
                      new InkWell(
//                          onTap: () {
//                            setState(() {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => CategoryListView()));
//                            });
//                          },
                       //   onTap: _playAnimation,
                          child: new Center(
                            child: new Container(
                              width: 220.0,
                              height: 45.0,
                              margin: const EdgeInsets.only(top: 228.5),
                              alignment: FractionalOffset.center,
                              decoration: new BoxDecoration(
                                  color: const Color.fromRGBO(229, 32, 32, 1.0),
                                  borderRadius: new BorderRadius.all(const Radius.circular(7.0))
                              ),
                              child: new Text(
                                "Đặt ngay",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: new CategoryScreen()
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: new SpecialOffer()
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: new TodayOffer()
                  )
                ],
              )
          )
        )
    );
  }
}