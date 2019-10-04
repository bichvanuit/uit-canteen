import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';
import 'package:uit_cantin/models/FoodInfo.dart';

class ItemWidget extends StatelessWidget {
  final FoodInfo food;
  final double heightContainer = 220;
  final double widthContainer = 170;
  final BoxDecoration _shadowDecoration = new BoxDecoration(boxShadow: [
    BoxShadow(
      color: Colors.black,
      blurRadius: 50,
      spreadRadius: 1.0,
      offset: Offset(
        10.0,
        10.0,
      ),
    )
  ]);

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
            width: widthContainer,
            height: heightContainer,
            child: new Stack(children: <Widget>[
              new Container(
                  height: heightContainer,
                  width: widthContainer,
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
              new Container(
                  padding: EdgeInsets.all(20),
                  child: new Container(
                      decoration: BoxDecoration(
                          color: food != null ? const Color.fromRGBO(229, 32, 32, 1.0) : Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: food != null
                          ? new Text(
                              "- " +
                                  (100 -
                                          (double.parse(food.discountPrice) /
                                              double.parse(food.price) *
                                              100))
                                      .round()
                                      .toString() +
                                  " %",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                          : null)),
              new Align(
                alignment: Alignment.bottomLeft,
                child: new Container(
                  decoration: _shadowDecoration,
                  margin: EdgeInsets.all(20),
                  child: food != null
                      ? new Text(food.foodName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white))
                      : null,
                ),
              )
            ])));
  }
}
