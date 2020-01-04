import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

class ItemWidget extends StatefulWidget {
  final FoodInfo food;
  final double heightContainer = 230;
  final double widthContainer = 200;

  ItemWidget({Key key, this.food}) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  DateTime now = DateTime.now();
  bool isService = true;

  @override
  void initState() {
    int hour = now.hour;
    if (hour < 7 || hour > 17) {
      setState(() {
        isService = false;
      });
    }
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          if ( !isService ||
              (widget.food == null ||
                  widget.food.quantity == null ||
                  widget.food.quantity <= 0))
            {
              return;
            } else {
            Navigator.push(
                context,
                SlideFromLeftPageRoute(
                    widget: ItemDetails(foodId: widget.food.foodId)
                )
            );
          }

        },
        child: new Container(
            decoration: BoxDecoration(
                border: Border.all(color: CanteenAppTheme.myGrey, width: 1.0)),
            height: 200,
            width: MediaQuery.of(context).size.width * 0.5,
            child: new Stack(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Stack(children: <Widget>[
                      new Container(
                        height: 180,
                        decoration: new BoxDecoration(
                          image: widget.food != null
                              ? new DecorationImage(
                                  image: new NetworkImage(widget.food.image),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                      ),
                    ]),
                    new Container(
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                      color: CanteenAppTheme.myGrey,
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                              child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                widget.food != null ? widget.food.foodName : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              new Container(
                                alignment: Alignment.topLeft,
                                child: new StarRating(
                                  size: 15.0,
                                  rating: widget.food == null ||
                                          widget.food.star == null
                                      ? 0
                                      : widget.food.star.toDouble(),
                                  color: Colors.orange,
                                  borderColor: Colors.grey,
                                ),
                              ),
                            ],
                          )),
                          new Expanded(
                              child: new Align(
                            alignment: Alignment.topRight,
                            child: new Container(
                                decoration: BoxDecoration(
                                    color: widget.food != null
                                        ? CanteenAppTheme.main
                                        : Color(0xFFE6E6E6),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 4),
                                child: widget.food != null
                                    ? new Text(
                                        "- " +
                                            (100 -
                                                    (double.parse(widget.food
                                                            .discountPrice) /
                                                        double.parse(
                                                            widget.food.price) *
                                                        100))
                                                .round()
                                                .toString() +
                                            " %",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))
                                    : null),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
                !isService ||
                        (widget.food == null ||
                            widget.food.quantity == null ||
                            widget.food.quantity <= 0)
                    ? new Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.7)),
                      )
                    : new Container()
              ],
            )));
  }
}
