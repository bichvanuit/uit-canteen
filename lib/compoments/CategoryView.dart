import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';

class CategoryView extends StatelessWidget {
  final FoodInfo foodInfo;

  const CategoryView({
    Key key,
    this.foodInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ItemDetails(food: foodInfo)));
          },
          splashColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 35,
                      ),
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                              color: CanteenAppTheme.white,
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: CanteenAppTheme.grey.withOpacity(0.2),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 5.0),
                              ]
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 48 + 35.0,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          foodInfo.foodName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.27,
                                            color: CanteenAppTheme.darkerText,
                                          )
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              FormatPrice.getFormatPrice(foodInfo.price),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: CanteenAppTheme.grey,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
//                                                  Text(
//                                                    foodInfo.foodType.toString(),
////                                                        "${category.rating}",
//                                                    textAlign: TextAlign.left,
//                                                    style: TextStyle(
//                                                      fontWeight: FontWeight.w200,
//                                                      fontSize: 18,
//                                                      letterSpacing: 0.27,
//                                                      color: CanteenAppTheme.grey,
//                                                    ),
//                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color:
                                                    CanteenAppTheme.main,
                                                    size: 20,
                                                  )
                                                ]
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              FormatPrice.getFormatPrice(foodInfo.discountPrice),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.27,
                                                color: CanteenAppTheme.main,
                                              ),
                                            ),
//                                            Container(
//                                              decoration: BoxDecoration(
//                                                color: CanteenAppTheme.nearlyBlue,
//                                                borderRadius: BorderRadius.all(
//                                                    Radius.circular(8.0)),
//                                              ),
//                                              child: Padding(
//                                                padding: const EdgeInsets.all(4.0),
//                                                child: Icon(
//                                                  Icons.add,
//                                                  color:
//                                                  CanteenAppTheme.nearlyWhite,
//                                                )
//                                              )
//                                            )
                                          ]
                                        )
                                      )
                                    ]
                                  )
                                )
                              )
                            ]
                          )
                        )
                      )
                    ]
                  )
                ),
                new Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    height: 80.0,
                    width: 110.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new NetworkImage(
                              foodInfo.image),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ],
            ),
        )
    );
  }
}
