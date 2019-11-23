import 'package:flutter/material.dart';
import 'package:uit_cantin/compoments/SpecialOffer.dart';
import 'package:uit_cantin/compoments/TodayOrder.dart';
import 'package:uit_cantin/compoments/AdvertisementWall.dart';
import 'package:uit_cantin/pages/Wallet.dart';

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
                new Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => WalletScreen()));
                      });
                    } ,
                    child: AdvertisementWall(),
                  ),
                ),
                  new Container(
                    margin: const EdgeInsets.only(top: 20.0),
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