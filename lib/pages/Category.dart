import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Category.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_cantin/pages/Menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';

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
  return _parseCategory(response.body);
}

class CategoryScreen extends StatefulWidget {
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen> {
  @override
  initState() {
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
            new Container(
                height: 100.0,
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
                          itemBuilder: (context, index) => Shimmer.fromColors(
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.white,
                              child: _createItemList(null)),
                        );

                      default:
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else
                          return createListView(context, snapshot);
                    }
                  },
                ))
          ],
        ));
  }

  Widget _createItemList(Category category) {
    return new Container(
        padding: EdgeInsets.only(right: 10),
        child: new GestureDetector(
            onTap: () {
              setState(() {
                Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                          new MenuScreen(categoryId: category.foodCategoryId, categoryName: category.foodCategoryName)));
              });
            },
            child: new Column(children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.height * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: new BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: category != null
                      ? new DecorationImage(
                          image: new NetworkImage(category.image),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                  border: new Border.all(
                    color: Colors.transparent,
                    width: 4.0,
                  ),
                ),
              ),
              new Center(
                  child: new Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: category != null
                          ? new Text(category.foodCategoryName)
                          : null))
            ])));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Category> listCategory = snapshot.data;
    return new ListView.builder(
        itemCount: listCategory.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return _createItemList(listCategory[position]);
        });
  }
}
