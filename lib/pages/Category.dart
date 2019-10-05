import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Category.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/compoments/CategoryItem.dart';

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

class CategoryScreen extends StatefulWidget {
  final Function callBack;

  const CategoryScreen({Key key, this.callBack}) : super(key: key);

  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  int selectCategory;
  var count = 9;
  Widget foodType;

  @override
  initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    if (selectCategory == null) {
      _fetchCategory().then((data) => setState(() {
            selectCategory = data[0].foodCategoryId;
          }));
    }
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
                            return ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              // Important code
                              itemBuilder: (context, index) =>
                                  Shimmer.fromColors(
                                      baseColor: CanteenAppTheme.shimmer,
                                      highlightColor: Colors.white,
                                      child: _createItemList(null)),
                            );
                          default:
                            if (snapshot.hasError) {
                              return new Text('Error: ${snapshot.error}');
                            } else {
                              return createListView(context, snapshot);
                            }
                        }
                      },
                    )),
                new SizedBox(
                  height: 15.0,
                ),
                selectCategory != null
                    ? new CategoryItem(
                        mainScreenAnimation: Tween(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * 3, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        mainScreenAnimationController: animationController,
                        categoryId: selectCategory,
                      )
                    : new Container(),
              ],
            )
          ],
        ));
  }

  Widget _createItemList(Category category) {
    return category != null
        ? Container(
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
                        selectCategory = category.foodCategoryId;
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
                                  color:
                                      selectCategory == category.foodCategoryId
                                          ? CanteenAppTheme.nearlyWhite
                                          : CanteenAppTheme.main,
                                )))))))
        : new Container(
            margin: const EdgeInsets.only(right: 10.0),
            width: 100.0,
            decoration: new BoxDecoration(
                color: CanteenAppTheme.main,
                borderRadius: BorderRadius.all(Radius.circular(24.0))),
          );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Category> listCategory = snapshot.data;
    return new ListView.builder(
        itemCount: listCategory.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          if (selectCategory == null) {
            selectCategory = listCategory[position].foodCategoryId;
          }
          return _createItemList(listCategory[position]);
        });
  }
}
