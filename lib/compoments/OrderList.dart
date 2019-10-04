import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Order.dart';
import 'package:stepper_touch/stepper_touch.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  final double heightContainer = 220;
  final double widthContainer = 100;

  OrderWidget({Key key, this.order}) : super(key: key);

  _removeProduct() {

  }

  _addProduct() {
  }

  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),
      height: 100,
        child: new GestureDetector(
            onTap: () {},
            child: new Row(
              children: <Widget>[
                new SizedBox(
                    width: widthContainer,
                    child: new Stack(children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.height*0.2,
                        height: MediaQuery.of(context).size.height*0.2,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: new DecorationImage(
                            image: new NetworkImage(order.image),
                            fit: BoxFit.cover,
                          ),
                          border: new Border.all(
                            color: Color.fromRGBO(229, 32, 32, 1.0),
                            width: 2.0,
                          ),
                        ),
                      )
                    ])),
                new Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          child: new Text(order.foodName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ))
              ],
            )),
    );
  }
}
