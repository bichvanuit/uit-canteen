import 'package:flutter/material.dart';
import 'package:uit_cantin/compoments/ItemWidget.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_multi_carousel/carousel.dart';

// A function that converts a response body into a List<Photo>
List<FoodInfo> _parseFoodDiscount(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<FoodInfo>((json) => FoodInfo.fromJson(json)).toList();
}

Future<List<FoodInfo>> _fetchFoodDiscout() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/food/get-food-discount',
      headers: requestHeaders);
  return _parseFoodDiscount(response.body);
}

class SpecialOffer extends StatefulWidget {
  _SpecialOffer createState() => _SpecialOffer();
}

class _SpecialOffer extends State<SpecialOffer> {

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
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: new Column(children: <Widget>[
          new Align(
              alignment: Alignment.centerLeft,
              child: new Text("Giảm giá hôm nay".toUpperCase(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))),
          new Container(
              height: 241.0,
              child: new FutureBuilder(
                future: _fetchFoodDiscout(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.white,
                            child: Container(
                                padding: EdgeInsets.only(right: 10, top: 20),
                                margin: EdgeInsets.only(right: 20),
                                child: new ItemWidget(food: null))),
                      );

                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return createListView(context, snapshot);
                  }
                },
              ))
        ]));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<FoodInfo> listFoodInfo = snapshot.data;
    return new ListView.builder(
        itemCount: listFoodInfo.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return new Container(
            margin: const EdgeInsets.only(right: 10.0, top: 12),
            child: new ItemWidget(food: listFoodInfo[position]),
          );
        });

  }
}
