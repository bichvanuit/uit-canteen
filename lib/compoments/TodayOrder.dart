import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodList.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/compoments/CategoryView.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';

// A function that converts a response body into a List<Photo>
List<FoodList> _parseFoodToday(String responseBody) {
  var parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<FoodList>((json) => FoodList.fromJson(json)).toList();
}

Future<List<FoodList>> _fetchFoodToday() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response =
  await http.get('$SERVER_NAME/food/get-all-food', headers: requestHeaders);
  return _parseFoodToday(response.body);
}

class TodayOffer extends StatefulWidget {
  final Function callBack;

  const TodayOffer({Key key, this.callBack}) : super(key: key);

  _TodayOffer createState() => _TodayOffer();
}

class _TodayOffer extends State<TodayOffer>{
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
              child: new Text("Hôm nay có gì".toUpperCase(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))),
          // Menu name
          new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new FutureBuilder(
                future: _fetchFoodToday(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new LoadingWidget()
                      ],
                    );
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return createListView(context, snapshot);
                  }
                },
              )),
        ]));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<FoodList> listFood = snapshot.data;

    return new ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: listFood.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new Text(listFood[position].nameType,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                  ),
                  new Container(
                    height: 130.0,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: new ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listFood[position].listFood.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, position1) {
                          return Container(
                              padding:
                              EdgeInsets.only(top: 20),
                              child: CategoryView(
                              //  foodInfo: null,
                                foodInfo: listFood[position].listFood[position1],
                              )
                          );
                        }),
                  )
                ],
              ));
        }
    );
  }
}
