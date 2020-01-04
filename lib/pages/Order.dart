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
import 'package:uit_cantin/pages/Home.dart';

List<CardGet> _parseCard(String responseBody) {
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
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
  bool isLoading;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    isLoading = true;
    totalOrder = 0;
    _fetchCard().then((data) => setState(() {
          setState(() {
            listCard = data;
            isLoading = false;
          });
          totalOrder = data
              .map<double>((m) => double.parse(m.discountPrice) * m.amount)
              .reduce((a, b) => a + b);
        }));

    super.initState();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  Widget createDialogRemove(CardGet card) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContentRemove(context, card),
    );
  }

  dialogContentRemove(BuildContext context, CardGet card) {
    _textFieldController.text = card.note == "null" ? "" : card.note;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 66.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Cảnh báo",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              new Text("Bạn muốn xóa " + card.foodName + " khỏi đơn hàng"),
              SizedBox(height: 25),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _removeFood(card);
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45.0,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0)),
                                border:
                                    Border.all(color: Colors.grey, width: 2.0)),
                            child: new Text("Xóa sản phẩm",
                                style: new TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45.0,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                                color: const Color.fromRGBO(229, 32, 32, 1.0),
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0))),
                            child: new Text("Đóng",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createDialog(CardGet card) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, card),
    );
  }

  dialogContent(BuildContext context, CardGet card) {
    _textFieldController.text = card.note == "null" ? "" : card.note;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 66.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Lưu ý của bạn",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Ví dụ: không hành"),
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              createDialogRemove(card),
                        );
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45.0,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0)),
                                border:
                                    Border.all(color: Colors.grey, width: 2.0)),
                            child: new Text("Xóa sản phẩm",
                                style: new TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: new GestureDetector(
                      onTap: () {
                        card.note = _textFieldController.text;
                        Navigator.of(context).pop();
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45.0,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                                color: const Color.fromRGBO(229, 32, 32, 1.0),
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0))),
                            child: new Text("Đóng",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _removeFood(CardGet card) async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_NAME/cart/remove-cart-item';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["food_id"] = card.foodId.toString();

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      //  isLoading = false;
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        setState(() {
          isLoading = false;
          listCard.removeAt(listCard.indexOf(card));
          totalOrder = totalOrder - int.parse(card.discountPrice) * card.amount;
        });
      } else {
        //    _showDialogSuccess();
      }
    }
  }

  _checkOut() async {
    var url = '$SERVER_NAME/cart/update-cart-item';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    List<dynamic> list = [];
    for (var item in listCard) {
      list.add(CardGet.toMapObject(item));
    }

    var requestBody = new Map<String, dynamic>();
    requestBody["list_food"] = jsonEncode(list);

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmOrderScreen(
                      totalOrder: totalOrder,
                    )));
      } else {
        //    _showDialogSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Widget _noProduct() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30),
        new Center(
          child: new Text("Bạn chưa có sản phẩm nào trong đơn hàng",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50.0,
          margin: EdgeInsets.only(top: 20.0),
          child: RaisedButton(
            color: Color.fromRGBO(229, 32, 32, 1.0),
            onPressed: () {
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              });
            },
            child: Text(
              "Mua hàng ngay".toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createBody() {
    return SafeArea(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      "ĐƠN HÀNG CỦA BẠN",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700),
                    )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    });
                  },
                  child: new Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(right: 10.0),
                    child: new Text(
                      "Thêm món",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.grey.shade700),
                    ),
                  ),
                ))
              ],
            ),
            listCard != null && listCard.length != 0
                ? new Column(
                    children: <Widget>[
                      listCard != null
                          ? new Container(
                              height: 383,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(16.0),
                                itemCount: listCard.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return _createItemList(listCard[position]);
                                },
                              ),
                            )
                          : new LoadingWidget(),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: CanteenAppTheme.grey.withOpacity(0.8),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 5.0),
                              ]
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Expanded(child: new Text("Tổng cộng", style: TextStyle(fontSize: 18.0),)),
                                  new Expanded(
                                      child: new Text(

                                          FormatPrice.getFormatPrice(
                                              totalOrder.toString()), style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 18.0), textAlign: TextAlign.right,),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: MaterialButton(
                                  height: 50.0,
                                  color: totalOrder == 0
                                      ? Colors.grey
                                      : Color.fromRGBO(229, 32, 32, 1.0),
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
                          ))
                    ],
                  )
                : isLoading ? new Container() : _noProduct()
          ]),
    );
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }

  Widget _createItemList(CardGet card) {
    return Stack(
      children: <Widget>[
        Container(
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
                                    totalOrder = totalOrder -
                                        int.parse(card.discountPrice);
                                  }
                                  if (card.amount == 0) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          createDialogRemove(card),
                                    );
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
                                  totalOrder = totalOrder +
                                      int.parse(card.discountPrice);
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
            top: 10,
            right: 0,
            child: new GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => createDialog(card),
                );
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: CanteenAppTheme.main,
                    borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.center,
                child: Center(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
