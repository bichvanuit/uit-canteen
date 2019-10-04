import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Payment.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:uit_cantin/pages/OrderSuccess.dart';

List<PaymentMethod> listMethod = <PaymentMethod>[
  new PaymentMethod(1, 'Tiền mặt',
      'https://benhviendongho.com/wp-content/uploads/2018/05/Tienmat_Icon_big-2-300x140.png'),
  new PaymentMethod(
      2, 'Zalopay', 'https://img1.apk.tools/150/1/f/9/vn.com.vng.zalopay.png'),
  new PaymentMethod(3, 'Momo', 'https://static.mservice.io/img/logo-momo.png')
];

class ConfirmOrderScreen extends StatefulWidget {
  @override
  _ConfirmOrder createState() => _ConfirmOrder();
}

class _ConfirmOrder extends State<ConfirmOrderScreen> {
  static final String path = "lib/src/pages/ecommerce/confirm_order1.dart";
  final String address = "Chabahil, Kathmandu";
  final String phone = "9818522122";
  final double total = 500;
  final double delivery = 100;
  int paymentId = 1;
  String result = "Quét mã";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận đơn hàng"),
        backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding:
      EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tổng cộng",
                style: Theme
                    .of(context)
                    .textTheme
                    .title,
              ),
              Text("20000", style: Theme
                  .of(context)
                  .textTheme
                  .title),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Phương thức thanh toán".toUpperCase())),
          Container(
            width: double.infinity,
            child: new ListView.builder(
                shrinkWrap: true,
                itemCount: listMethod.length,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, position) {
                  return RadioListTile(
                    groupValue: true,
                    value: listMethod[position].methodId == paymentId
                        ? true
                        : false,
                    title: Text(listMethod[position].methodName),
                    onChanged: (value) {
                      setState(() {
                        paymentId = listMethod[position].methodId;
                      });
                    },
                  );
                }),
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Vị trí".toUpperCase())),
          Container(
              padding: EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(result),
                  ),
                  new Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 40.0,
                      width: 40.0,
                      child: FittedBox(
                        child: FloatingActionButton.extended(
                          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
                          icon: Icon(Icons.camera_alt),
                          label: Text("Quét"),
                          onPressed: _scanQR,
                        ),
                      ),
                    ),
                  )
                ],
              )),
          Container(
            width: double.infinity,
            height: 50.0,
            margin:
            EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height * 0.2),
            child: RaisedButton(
              color: Color.fromRGBO(229, 32, 32, 1.0),
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderSuccessScreen()));
                });
              },
              child: Text(
                "Xác nhận".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
