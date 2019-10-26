import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:flutter_rating/flutter_rating.dart';

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
                  builder: (context) => new ItemDetails(food: food)));
        },
        child: new SizedBox(
            height: 450,
            width: MediaQuery.of(context).size.width * 0.7,
            child: new Column(
              children: <Widget>[
                new Stack(children: <Widget>[
                  new Container(
                      height: 320,
                      decoration: new BoxDecoration(
                        image: food != null
                            ? new DecorationImage(
                                image: new NetworkImage(food.image),
                                fit: BoxFit.cover)
                            : null,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: new Container(
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: <Color>[
                              const Color.fromRGBO(0, 0, 0, 0.5),
                              const Color.fromRGBO(51, 51, 63, 0.1),
                            ],
                            stops: [0.2, 1.0],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.0, 1.0),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      )),
                ]),
                new Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(food != null ? food.foodName : "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
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
                                        ? const Color.fromRGBO(229, 32, 32, 1.0)
                                        : Color(0xFFE6E6E6),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                padding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                                        fontWeight: FontWeight.bold, fontSize: 18))
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
