import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/models/History.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/compoments/DialogMethodRecharge.dart';

List<History> _parseHistory(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  return parsed.map<History>((json) => History.fromJson(json)).toList();
}

Future<List<History>> _fetchHistory() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/order/get-history-order',
      headers: requestHeaders);
  List<History> listCategory = _parseHistory(response.body);

  return listCategory;
}

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: CanteenAppTheme.main,
          //  title: appBarTitle,
          iconTheme: new IconThemeData(color: Colors.white),
          //  leading: _isSearching ? const BackButton() : null,
          title: Text("Hoạt động của tôi"),
        ),
        body: SingleChildScrollView(
      child: new Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: new Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new FutureBuilder(
                  future: _fetchHistory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return new Text("loading");
                      default:
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else
                          return createListView(context, snapshot);
                    }
                  },
                )),
          ],
        ),
      ),
    ));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<History> listHistory = snapshot.data;

    return new ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: listHistory.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return Container(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                child: new Text(listHistory[position].createDate,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              ),
              new Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listHistory[position].foodInfo.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, position1) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogRating(foodInfo: listHistory[position].foodInfo[position1]),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 12.0),
                                  child: Row(children: <Widget>[
                                    SizedBox(
                                      width: 35,
                                    ),
                                    Expanded(
                                        child: Container(
                                            height: 90,
                                            decoration: new BoxDecoration(
                                                color: CanteenAppTheme.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: CanteenAppTheme
                                                          .grey
                                                          .withOpacity(0.2),
                                                      offset: Offset(1.1, 1.1),
                                                      blurRadius: 5.0),
                                                ]),
                                            child: Row(children: <Widget>[
                                              SizedBox(
                                                width: 65.0,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                right: 10.0),
                                                        child: Text(
                                                            listHistory[
                                                                    position]
                                                                .foodInfo[
                                                                    position1]
                                                                .foodName,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.27,
                                                              color:
                                                                  CanteenAppTheme
                                                                      .darkerText,
                                                            ))),
//                                                  new Container(
//                                                    alignment:
//                                                        Alignment.topLeft,
//                                                    child: new StarRating(
//                                                      size: 15.0,
//                                                      rating: 4.5,
//                                                      color: Colors.orange,
//                                                      borderColor: Colors.grey,
//                                                    ),
//                                                  ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8,
                                                              right: 10.0,
                                                              top: 5.0),
                                                      child: Container(
                                                          child: Text(
                                                        listHistory[position]
                                                                .foodInfo[
                                                                    position1]
                                                                .quantity
                                                                .toString() +
                                                            " x " +
                                                            FormatPrice.getFormatPrice(
                                                                listHistory[
                                                                        position]
                                                                    .foodInfo[
                                                                        position1]
                                                                    .price),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color: Colors.grey,
                                                        ),
                                                      )),
                                                    ),
                                                  ])))
                                            ])))
                                  ])),
                              new Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  height: 70.0,
                                  width: 90.0,
                                  decoration: new BoxDecoration(
                                    //  color: CanteenAppTheme.shimmer,
                                    image: new DecorationImage(
                                        image: new NetworkImage(
                                            listHistory[position]
                                                .foodInfo[position1]
                                                .image),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ));
        });
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 5.0,
      width: 5.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
