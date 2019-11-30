import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:uit_cantin/canteenAppTheme.dart';

class ItemWidget extends StatelessWidget {
  final FoodInfo food;
  final double heightContainer = 230;
  final double widthContainer = 200;

  ItemWidget({Key key, this.food}) : super(key: key);

  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ItemDetails(foodId: food.foodId)));
        },
        child: new Container(
          decoration: BoxDecoration(
            border: Border.all(color: CanteenAppTheme.myGrey, width: 1.0)
          ),
            height: 200,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.5,
            child: new Column(
              children: <Widget>[
                new Stack(children: <Widget>[
                  new Container(
                    height: 180,
                    decoration: new BoxDecoration(
                        image: food != null
                            ? new DecorationImage(
                            image: new NetworkImage(food.image),
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
                              new Text(food != null ? food.foodName : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 16.0),),
                              new Container(
                                alignment: Alignment.topLeft,
                                child: new StarRating(
                                  size: 15.0,
                                  rating: 4.5,
                                  color: Colors.orange,
                                  borderColor: Colors.grey,
                                ),
                              ),
                            ],
                          )
                      ),
                      new Expanded(
                          child: new Align(
                            alignment: Alignment.topRight,
                            child: new Container(
                                decoration: BoxDecoration(
                                    color: food != null
                                        ? CanteenAppTheme.main
                                        : Color(0xFFE6E6E6),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 4),
                                child: food != null
                                    ? new Text(
                                    "- " +
                                        (100 -
                                            (double.parse(
                                                food.discountPrice) /
                                                double.parse(food.price) *
                                                100))
                                            .round()
                                            .toString() +
                                        " %",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                                    : null),
                          )
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
