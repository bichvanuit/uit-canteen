import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/pages/ConfirmOrder.dart';
import 'package:uit_cantin/models/CardGet.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';

List<CardGet> _parseCard(String responseBody) {
  final parsed = json
      .decode(responseBody)["data"]
      .cast<Map<String, dynamic>>();
  return parsed.map<CardGet>((json) => CardGet.fromJson(json)).toList();
}

Future<List<CardGet>> _fetchCard() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/cart/get-list-cart-item',
      headers: requestHeaders);
  return _parseCard(response.body);
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<OrderScreen> {
  double totalOrder;
  List<CardGet> listCard;

  @override
  void initState() {
    totalOrder = 0;
    _fetchCard().then((data) => setState(() {
      setState(() {
        listCard = data;
      });
          totalOrder = data
              .map<double>((m) => double.parse(m.discountPrice) * m.amount)
              .reduce((a, b) => a + b);
        }));

    super.initState();
  }

  _checkOut() async {
    var url = '$SERVER_NAME/cart/update-cart-item';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["list_food"] = listCard;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      //  isLoading = false;
      var status = responseBody["status"];
      print(status);
      if (status == STATUS_SUCCESS) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmOrderScreen(totalOrder: totalOrder,)));
      } else {
        //    _showDialogSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                child: Text(
                  "ĐƠN HÀNG CỦA BẠN",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700),
                )),
            Expanded(
                child: listCard != null ? ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: listCard.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _createItemList(listCard[position]);
                  },
                ): new LoadingWidget()),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Tổng cộng     " +
                        FormatPrice.getFormatPrice(totalOrder.toString()),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      height: 50.0,
                      color: totalOrder == 0 ? Colors.grey :Color.fromRGBO(229, 32, 32, 1.0),
                      child: Text(
                        "Thanh toán".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (totalOrder == 0) {

                        } else {
                          _checkOut();
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createItemList(CardGet card) {
    return Stack(
      children: <Widget>[
        Container(
            height: 120,
            width: double.infinity,
            margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: CanteenAppTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: CanteenAppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 5.0),
                ]),
            child: Row(
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 100.0,
                  child: card != null
                      ? Image.network(card.image, fit: BoxFit.cover)
                      : null,
                ),
                SizedBox(width: 10.0),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      card.foodName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      FormatPrice.getFormatPrice(card.discountPrice),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.grey),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (card.amount > 0) {
                                    card.amount = card.amount - 1;
                                    totalOrder = totalOrder - int.parse(card.discountPrice);
                                  }
                                });
                              },
                              child: new Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: new Center(
                                  child: new Icon(Icons.remove, size: 18),
                                ),
                              ),
                            ),
                            new Container(
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: new Text(
                                    card.amount.toString(),
                                    //   '$intCount',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                            new GestureDetector(
                              onTap: () {
                                setState(() {
                                  card.amount++;
                                  totalOrder = totalOrder + int.parse(card.discountPrice);
                                });
                              },
                              child: new Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black, width: 1.5),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: new Center(
                                  child: new Icon(Icons.add, size: 18),
                                ),
                              ),
                            )
                          ]),
                    )
                  ],
                )),
              ],
            )),
        Positioned(
          top: 20,
          right: 0,
          child: Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.all(0.0),
              color: Color.fromRGBO(229, 32, 32, 1.0),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }
}
