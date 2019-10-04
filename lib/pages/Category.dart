import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Category.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_cantin/pages/Menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/models/FoodType.dart';
import 'package:uit_cantin/compoments/CategoryView.dart';

List<Category> _parseCategory(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<Category>((json) => Category.fromJson(json)).toList();
}

Future<List<Category>> _fetchCategory() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/food/get-food-category',
      headers: requestHeaders);
  List<Category> listCategory = _parseCategory(response.body);

  return listCategory;
}

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

class CategoryScreen extends StatefulWidget {
  final Function callBack;

  const CategoryScreen({Key key, this.callBack}) : super(key: key);

  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  int selectCategory;

  @override
  initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: new Column(
          children: <Widget>[
            new Align(
                alignment: Alignment.centerLeft,
                child: new Text("Danh mục".toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
            new Column(
              children: <Widget>[
                new Container(
                    height: 50.0,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new FutureBuilder(
                      future: _fetchCategory(),
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
                    )),
                new Container(
                  height: 120.0,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: selectCategory != null
                      ? _createFoodType(selectCategory)
                      : null,
                )
              ],
            )
          ],
        ));
  }

  Widget _createFoodType(int foodCategoryId) {
//    return new Text(foodCategoryId.toString());
    return FutureBuilder(
      future: _fetchFoodType(foodCategoryId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListViewFoodType(context, snapshot);
        }
      },
    );
  }

  Widget createListViewFoodType(BuildContext context, AsyncSnapshot snapshot) {
    List<FoodType> listFoodType = snapshot.data;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16),
      itemCount: listFoodType.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var count = listFoodType.length > 10 ? 10 : listFoodType.length;
        var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval((1 / count) * index, 1.0,
                curve: Curves.fastOutSlowIn)));
        animationController.forward();
        return null;

//        return CategoryView(
//          foodInfo: listFoodType[index],
//          animation: animation,
//          animationController: animationController,
//          callback: () {
//            widget.callBack();
//          },
//        );
      },
    );
  }

  Widget _createItemList(Category category) {
    return Container(
        margin: const EdgeInsets.only(right: 10.0),
        height: 20.0,
        decoration: new BoxDecoration(
            color: selectCategory == category.foodCategoryId
                ? CanteenAppTheme.main
                : CanteenAppTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            border: new Border.all(color: CanteenAppTheme.main)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                splashColor: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                onTap: () {
                  setState(() {
                    //  categoryType = categoryTypeData;
                  });
                },
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    child: Center(
                        child: Text(category.foodCategoryName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 0.27,
                              color: selectCategory == category.foodCategoryId
                                  ? CanteenAppTheme.nearlyWhite
                                  : CanteenAppTheme.main,
                            )))))));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Category> listCategory = snapshot.data;
    return new ListView.builder(
        itemCount: listCategory.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          if (selectCategory == null) {
            selectCategory = listCategory[position].foodCategoryId;
            _createFoodType(selectCategory);
          }
          return _createItemList(listCategory[position]);
        });
  }
}
