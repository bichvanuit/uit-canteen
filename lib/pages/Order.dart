import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/pages/ConfirmOrder.dart';
import 'package:uit_cantin/models/CardGet.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';


List<CardGet> _parseCard(String responseBody) {
  final parsed = json.decode(responseBody)["data"]["list_food"].cast<Map<String, dynamic>>();
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
  @override
  void initState() {
    super.initState();
  }

  static final String path = "lib/src/pages/ecommerce/cart1.dart";
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
                padding: EdgeInsets.symmetric(horizontal:16.0, vertical: 30.0),
                child: Text("ĐƠN HÀNG CỦA BẠN", style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700
                ),)),
            Expanded(
                child: new FutureBuilder(
                  future: _fetchCard(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return new Container();
                      default:
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else
                          return createListView(context, snapshot);
                    }
                  },
                )
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Tổng cộng     50000", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),),
                  SizedBox(height: 20.0,),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      height: 50.0,
                      color: Color.fromRGBO(229, 32, 32, 1.0),
                      child: Text("Thanh toán".toUpperCase(), style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmOrderScreen()));
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

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<CardGet> listOrder = snapshot.data;
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: listOrder.length,
      itemBuilder: (BuildContext context, int index){
        return Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: Image.network(listOrder[index].image),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(listOrder[index].foodName, style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            ),),
                            SizedBox(height: 20.0,),
                            Text('15.000', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 15,
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  padding: EdgeInsets.all(0.0),
                  color:  Color.fromRGBO(229, 32, 32, 1.0),
                  child: Icon(Icons.clear, color: Colors.white,),
                  onPressed: () {},
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
