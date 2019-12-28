import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CategoryView extends StatelessWidget {
  final FoodInfo foodInfo;

  const CategoryView({
    Key key,
    this.foodInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
//        width: MediaQuery.of(context).size.width,
//        decoration: BoxDecoration(
//          color: CanteenAppTheme.shimmer
//        ),
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => ItemDetails(foodId: foodInfo.foodId),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 2000),
          ),
        );
      },
      splashColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              margin: const EdgeInsets.only(right: 12.0),
              child: Row(children: <Widget>[
                SizedBox(
                  width: 35,
                ),
                Expanded(
                    child: Container(
                        decoration: new BoxDecoration(
                            color: CanteenAppTheme.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: CanteenAppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),

                            ],
                          ),
                        child: Row(children: <Widget>[
                          SizedBox(
                            width: 65.0,
                          ),
                          Expanded(
                              child: Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(top: 10, right: 10.0),
                                    child: Text(foodInfo.foodName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          letterSpacing: 0.27,
                                          color: CanteenAppTheme.darkerText,
                                        ))),
                                new Container(
                                  alignment: Alignment.topLeft,
                                  child: new StarRating(
                                    size: 15.0,
                                    rating: foodInfo == null || foodInfo.star == null ? 0 : foodInfo.star.toDouble(),
                                    color: Colors.orange,
                                    borderColor: Colors.grey,
                                  ),
                                ),
                                Text(
                                    foodInfo.discountPrice !=
                                        foodInfo.price ?
                                    FormatPrice.getFormatPrice(
                                        foodInfo.price) : "",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.w200,
                                      fontSize: 12,
                                      letterSpacing: 0.27,
                                      color:
                                      CanteenAppTheme.grey,
                                      decoration: TextDecoration
                                          .lineThrough,
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, right: 10.0, top: 5.0),
                                    child: Container(
                                        child: Text(
                                           FormatPrice.getFormatPrice(
                                              foodInfo.discountPrice),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.27,
                                            color: foodInfo.discountPrice != foodInfo.price ? CanteenAppTheme.main : Colors.grey,
                                          ),
                                        )),),
                              ])))
                        ])))
              ])),
//          new Container(
//            width: MediaQuery.of(context).size.width * 0.75,
//            margin: const EdgeInsets.only(right: 12.0, left: 35.0),
//            decoration: BoxDecoration(
//             // color: Colors.red
//               color: Color.fromRGBO(255, 255, 255, 0.7)
//            ),
//          ),
          new Container(
              margin: const EdgeInsets.only(top: 20.0),
              height: 70.0,
              width: 90.0,
              decoration: new BoxDecoration(
                //  color: CanteenAppTheme.shimmer,
                image: foodInfo != null
                    ? new DecorationImage(
                        image: new NetworkImage(foodInfo.image),
                        fit: BoxFit.cover)
                    : null,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
//          new Container(
//            margin: const EdgeInsets.only(top: 20.0),
//            height: 70.0,
//            width: 90.0,
//            decoration: BoxDecoration(
//              // color: Colors.red
//                color: Color.fromRGBO(255, 255, 255, 0.7),
//              borderRadius: BorderRadius.all(Radius.circular(10)),
//            ),
//          ),
        ],
      ),
    ));
  }
}
