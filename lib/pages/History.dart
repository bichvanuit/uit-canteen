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
import 'package:uit_cantin/pages/ItemDetails.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

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
  bool isLoading;
  List<History> listHistory;

  @override
  void initState() {
    isLoading = true;
    _fetchHistory().then((data) => setState(() {
          setState(() {
            listHistory = data;
            isLoading = false;
          });
        }));

    super.initState();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

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
        body: isLoading ? _createProgress() : _createBody()
    );
  }

  Widget _createBody() {
    return SingleChildScrollView(
      child: new Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: new Column(
          children: <Widget>[
            listHistory != null && listHistory.length > 0 ? new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new ListView.builder(
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
                                child: new Text(
                                    listHistory[position].createDate,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                              ),
                              new Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                child: new ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                    listHistory[position].foodInfo.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, position1) {
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                DialogRating(
                                                    foodInfo: listHistory[
                                                    position]
                                                        .foodInfo[position1]),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,

                                                  child: Row(children: <Widget>[
                                                    SizedBox(
                                                      width: 35,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                            height: 90,
                                                            decoration: new BoxDecoration(
                                                                color:
                                                                CanteenAppTheme
                                                                    .white,
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        16.0)),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                      color: CanteenAppTheme
                                                                          .grey
                                                                          .withOpacity(
                                                                          0.2),
                                                                      offset: Offset(
                                                                          1.1,
                                                                          1.1),
                                                                      blurRadius:
                                                                      5.0),
                                                                ]),
                                                            child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    width: 65.0,
                                                                  ),
                                                                  GestureDetector(
                                                                    child: Container(
                                                                        child: Container(
                                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                              Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                      top:
                                                                                      10,
                                                                                      right:
                                                                                      0.0),
                                                                                  child: Text(
                                                                                      listHistory[position].foodInfo[position1].foodName,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      textAlign: TextAlign.left,
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 18,
                                                                                        letterSpacing: 0.27,
                                                                                        color: CanteenAppTheme.darkerText,
                                                                                      ))),
//
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .only(
                                                                                    bottom:
                                                                                    8,
                                                                                    right:
                                                                                    10.0,
                                                                                    top:
                                                                                    5.0),
                                                                                child: Container(
                                                                                    child: Text(
                                                                                      listHistory[position].foodInfo[position1].quantity.toString() +
                                                                                          " x " +
                                                                                          FormatPrice.getFormatPrice(listHistory[position].foodInfo[position1].price),
                                                                                      textAlign:
                                                                                      TextAlign.left,
                                                                                      style:
                                                                                      TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight.w600,
                                                                                        fontSize:
                                                                                        18,
                                                                                        letterSpacing:
                                                                                        0.27,
                                                                                        color:
                                                                                        Colors.grey,
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ]))),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () {
                                                                          Navigator.push(
                                                                              context,
                                                                              SlideFromLeftPageRoute(
                                                                                  widget: ItemDetails(foodId: listHistory[position].foodInfo[position1].foodId)
                                                                              )
                                                                          );
                                                                    },
                                                                    child: new Container(
                                                                      //    padding: const EdgeInsets.only(right: 5.0),
                                                                        child: new Text(
                                                                          "Đặt hàng lại",
                                                                          style:
                                                                          TextStyle(color: CanteenAppTheme.main, fontSize: 16.0,
                                                                              fontWeight: FontWeight.bold),
                                                                        )),
                                                                  ),
                                                                ]))),
                                                  ])),
                                              new Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0),
                                                  height: 70.0,
                                                  width: 90.0,
                                                  decoration: new BoxDecoration(
                                                    //  color: CanteenAppTheme.shimmer,
                                                    image: new DecorationImage(
                                                        image: new NetworkImage(
                                                            listHistory[
                                                            position]
                                                                .foodInfo[
                                                            position1]
                                                                .image),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            10)),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ));
                    })) : new Container()
          ],
        ),
      ),
    );
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
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
