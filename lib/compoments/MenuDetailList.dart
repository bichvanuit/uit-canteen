import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';

class MenuDetailList extends StatelessWidget {
  final FoodInfo food;
  final bool horizontal;

  MenuDetailList(this.food, {this.horizontal = true});

  MenuDetailList.vertical(this.food) : horizontal = false;

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0),
        alignment:
            horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
        child: new Container(
          width: 92,
          height: 92,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: food != null
                ? new DecorationImage(
                    image: new NetworkImage(food.image),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            border: new Border.all(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
        ));

    final planetCard = new Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              margin: new EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(height: 4.0),
                  food != null
                      ? new Text(food.foodName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold))
                      : null,
                  new Container(height: 4.0),
                  food != null
                      ? new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              new Expanded(
                                  flex: 2,
                                  child: new Text(food.discountPrice + ' ₫',
                                      style: new TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0))),
                              new Expanded(
                                  flex: 1,
                                  child: new Text(food.price + ' ₫',
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          color:
                                              Color.fromRGBO(51, 51, 51, 0.4),
                                          decoration:
                                              TextDecoration.lineThrough))),
                            ])
                      : null,
                  /*new Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: new StarRating(
                      size: 18.0,
                      rating: food.star,
                      color: Colors.orange,
                      borderColor: Colors.grey,
                    ),
                  )*/
                ],
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new Align(
              alignment: Alignment.centerRight,
              child: new Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
      height: horizontal ? 124.0 : 154.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 46.0)
          : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(color: const Color.fromRGBO(229, 32, 32, 1.0)),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
      ),
    );

    return new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ItemDetails(food: food)));
        },
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 15.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        ));
  }
}
