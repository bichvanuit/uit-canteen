import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/MenuDetail.dart';
import 'package:uit_cantin/models/FoodType.dart';

class MenuList extends StatelessWidget {
  final FoodType foodType;
  final bool horizontal;

  MenuList(this.foodType, {this.horizontal = true});

  MenuList.vertical(this.foodType) : horizontal = false;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new MenuDetailScreen(
                      categoryId: foodType.foodCategoryId,
                      foodType: foodType.foodTypeId)));
        },
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 15.0,
          ),
          child: new Stack(
            children: <Widget>[
              new Container(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      flex: 3,
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                        child: new Column(
                          crossAxisAlignment: horizontal
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(height: 4.0),
                            foodType != null
                                ? new Text(foodType.foodTypeName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))
                                : null,
                            foodType != null
                                ? new Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Image.asset('assets/cutlery.png',
                                        height: 18.0),
                                    new Container(width: 8.0),
                                    new Text(
                                        foodType.amount.toString() +
                                            " sản phẩm",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontStyle: FontStyle.italic)),
                                  ]),
                            )
                                : null,
                            foodType != null
                                ? new Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Image.asset('assets/sale.png',
                                        height: 18.0),
                                    new Container(width: 8.0),
                                    new Text(
                                        foodType.amountDiscount
                                            .toString() +
                                            " đang giảm giá",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontStyle: FontStyle.italic)),
                                  ]),
                            )
                                : null,
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
                  border: new Border.all(
                      color: const Color.fromRGBO(229, 32, 32, 1.0)),
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(vertical: 16.0),
                alignment: horizontal
                    ? FractionalOffset.centerLeft
                    : FractionalOffset.center,
                child: new Container(
                  width: 92,
                  height: 92,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: foodType != null
                        ? new DecorationImage(
                      image: new NetworkImage(foodType.image),
                      fit: BoxFit.cover,
                    )
                        : null,
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: Colors.transparent,
                      width: 4.0,
                    ),
                  ),
                ),
              ),
            ],
          )

        ));
  }
}
