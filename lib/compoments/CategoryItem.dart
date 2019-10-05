import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/models/FoodType.dart';

List<FoodType> _parseFoodType(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<FoodType>((json) => FoodType.fromJson(json)).toList();
}

Future<List<FoodType>> _fetchFoodType(categoryId) async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get(
      '$SERVER_NAME/food/get-food-type?food_category_id=' +
          categoryId.toString(),
      headers: requestHeaders);
  return _parseFoodType(response.body);
}

class CategoryItem extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;
  final categoryId;

  const CategoryItem(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.categoryId})
      : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<FoodType> listFoodType = snapshot.data;
    List<ColorCustom> colors = [
      new ColorCustom(0xFFFA7D82,0xFFFFB295),
      new ColorCustom(0xFF738AE6,0xFF5C5EDD),
      new ColorCustom(0xFFFE95B6,0xFFFF5287),
      new ColorCustom(0xFF6F72CA,0xFF1E1466),
    ];
    return new ListView.builder(
        itemCount: listFoodType.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / listFoodType.length) * position, 1.0,
                  curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return CategoryItemDetail(
            foodType: listFoodType[position],
            animation: animation,
            animationController: animationController,
            color: colors[position % 4],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 230.0,
        child: new FutureBuilder(
          future: _fetchFoodType(widget.categoryId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
//                        return ListView.builder(
//                          itemCount: 3,
//                          scrollDirection: Axis.horizontal,
//                          // Important code
//                          itemBuilder: (context, index) => Shimmer.fromColors(
//                              baseColor: Colors.grey[400],
//                              highlightColor: Colors.white,
//                              child: _createItemList(null, false)),
//                        );

              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return createListView(context, snapshot);
            }
          },
        ));
  }
}

class ColorCustom{
  int startColor;
  int endColor;


  ColorCustom(
    this.startColor,
    this.endColor
  );
}

class CategoryItemDetail extends StatelessWidget {
  final FoodType foodType;
  final AnimationController animationController;
  final Animation animation;
  final ColorCustom color;

  const CategoryItemDetail(
      {Key key, this.foodType, this.animationController, this.animation, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color(color.endColor).withOpacity(0.6),
                              offset: Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Color(color.startColor),
                            Color(color.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 70, left: 10.0, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              foodType.foodTypeName,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 0.2,
                                color: CanteenAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      foodType.foodTypeName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: CanteenAppTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Row(
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
                            new Container(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: CanteenAppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(left: 8.0, top: 8.0),
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: new NetworkImage(foodType.image),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}