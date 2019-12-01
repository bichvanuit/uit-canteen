import 'package:flutter/material.dart';

import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/services/FormatPrice.dart';

Widget fullAppbar(BuildContext context, String fullname, String totalPrice) {
  return PreferredSize(
    preferredSize: Size.fromHeight(160.0),
    child: GradientAppBar(
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomPaint(
            painter: CircleOne(),
          ),
          CustomPaint(
            painter: CircleTwo(),
          ),
        ],
      ),
      title: Container(
        margin: EdgeInsets.only(top: 20),
        child: Text(
          'Chào ' + fullname + "!",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        )
      ),
//      actions: <Widget>[
//        Container(
//          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
//          child: Image.asset('assets/images/photo.png'),
//        ),
//      ],
      elevation: 0,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [CanteenAppTheme.HeaderBlueDark, CanteenAppTheme.HeaderBlueLight],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(8),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: CanteenAppTheme.HeaderGreyLight,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bạn có đơn hàng cần thanh toán',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Tổng cộng: ' + FormatPrice.getFormatPrice(totalPrice),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget emptyAppbar() {
  return PreferredSize(
    preferredSize: Size.fromHeight(75.0),
    child: GradientAppBar(
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomPaint(
            painter: CircleOne(),
          ),
          CustomPaint(
            painter: CircleTwo(),
          ),
        ],
      ),
      title: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hello Brenda!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Text(
              'Today you have no tasks',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: Image.asset('assets/images/photo.png'),
        ),
      ],
      elevation: 0,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [CanteenAppTheme.HeaderBlueDark, CanteenAppTheme.HeaderBlueLight],
      ),
    ),
  );
}

class CircleOne extends CustomPainter {
  Paint _paint;

  CircleOne() {
    _paint = Paint()
      ..color = CanteenAppTheme.HeaderCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(28.0, 0.0), 99.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CircleTwo extends CustomPainter {
  Paint _paint;

  CircleTwo() {
    _paint = Paint()
      ..color = CanteenAppTheme.HeaderCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(-30, 20), 50.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
