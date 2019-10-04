import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:uit_cantin/compoments/MenuDetailList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:shimmer/shimmer.dart';

List<FoodInfo> _parseListFood(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<FoodInfo>((json) => FoodInfo.fromJson(json)).toList();
}

Future<List<FoodInfo>> _fetchListFood(foodTypeId) async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/food/get-list-food?food_type_id=' + foodTypeId.toString(),
      headers: requestHeaders);
  return _parseListFood(response.body);
}

class MenuDetailScreen extends StatefulWidget {
  final int categoryId;
  final int foodType;

  MenuDetailScreen({Key key, this.categoryId, this.foodType}) : super(key: key);

  @override
  _MenuDetailState createState() => new _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetailScreen> {
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
            'Thông tin ',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: new Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: new SingleChildScrollView(
                child: new Column(children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new FutureBuilder(
                        future: _fetchListFood(widget.foodType),
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
                                    child: new MenuDetailList(null)),
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
    List<FoodInfo> listFoodInfo = snapshot.data;
    return new ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: listFoodInfo.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return new MenuDetailList(listFoodInfo[position]);
        });
  }
}
