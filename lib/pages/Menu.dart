import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodType.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_cantin/compoments/MenuList.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';

// A function that converts a response body into a List<Photo>
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

class MenuScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  MenuScreen({Key key, this.categoryId, this.categoryName}) : super(key: key);

  @override
  _MenuPagerState createState() => new _MenuPagerState();
}

class _MenuPagerState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Colors.black),
          title: Text(
            widget.categoryName,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: new Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background1.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: new SingleChildScrollView(
                child: new Column(children: <Widget>[
              new Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new FutureBuilder(
                    future: _fetchFoodType(widget.categoryId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.vertical,
                            // Important code
                            itemBuilder: (context, index) => Shimmer.fromColors(
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.white,
                                child: new MenuList(null)),
                          );

                        default:
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          else
                            return createListView(context, snapshot);
                      }
                    },
                  ))
            ]))));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<FoodType> listFoodType = snapshot.data;
    return new ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: listFoodType.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return new MenuList(listFoodType[position]);
        });
  }
}
