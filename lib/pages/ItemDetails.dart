import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/Home.dart';
import 'package:uit_cantin/models/CartInfo.dart';
import 'package:uit_cantin/services/Token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/FormatPrice.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:uit_cantin/pages/DeliveryMethod.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

Future<FoodInfo> _fetchProduct(int foodId) async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/food/get-detail-food?food_id=' + foodId.toString(),
      headers: requestHeaders);
  final parsed = json.decode(response.body)["data"];
  return FoodInfo.fromJson(parsed);
}

class ItemDetails extends StatefulWidget {
  final int foodId;

  ItemDetails({Key key, this.foodId}) : super(key: key);

  _ItemDetails createState() => new _ItemDetails();
}

class _ItemDetails extends State<ItemDetails> {
  var intCount = 1;
  var note;
  bool isLoading;

  FoodInfo foodInfo = new FoodInfo();


  @override
  initState() {
    isLoading = true;
    _fetchProduct(widget.foodId).then((data) =>
        setState(() {
          foodInfo = data;
          isLoading = false;
        })
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    intCount = 1;
    note = "";
    isLoading = false;
  }

  Widget createDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
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
            children: <Widget>[
              Text(
                "Thông báo",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Bạn có một đơn hàng đang chờ, thêm vào giỏ hàng đồng nghĩa với việc hủy đơn hàng cũ bạn đã thanh toán",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      SlideFromLeftPageRoute(
                          widget: DeliveryMethodScreen()
                      )
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
                          color: const Color.fromRGBO(229, 32, 32, 1.0),
                          borderRadius:
                          new BorderRadius.all(const Radius.circular(5.0))),
                      child: new Text("Hoàn tất đơn hàng",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ))),
                ),
              ),
              SizedBox(height: 10),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _cancelOrder();
                },
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: new Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 45.0,
                      alignment: FractionalOffset.center,
                      decoration: new BoxDecoration(
                          borderRadius:
                          new BorderRadius.all(const Radius.circular(5.0)),
                          border: Border.all(color: Colors.grey, width: 2.0)),
                      child: new Text("Tiếp tục thêm vào giỏ hàng",
                          style: new TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _cancelOrder() async {
    var url = '$SERVER_NAME/order/cancel';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var response =
    await http.post(url, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        _addToCard();
      }
    }
  }
  _addToCard() async {
    CardInfo cardInfo = new CardInfo();
    cardInfo.foodId = foodInfo.foodId.toString();
    cardInfo.note = note.toString();
    cardInfo.quantity = intCount.toInt().toString();
    var url = '$SERVER_NAME/cart/add-cart-item';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var response =
        await http.post(url, body: cardInfo.toMap(), headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      isLoading = false;
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        Navigator.of(context).pop();
        setState(() {
          Navigator.push(
              context,
              SlideFromLeftPageRoute(
                  widget: OrderScreen()
              )
          );
        });
      } else {
        _showDialogSuccess();
      }
    }
  }


  void _postOrder() async {

    Token token = new Token();
    final tokenValue = await token.getMobileWaiting();
    if (tokenValue == '') {
      _addToCard();
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              createDialog(),
        );
    }
  }

  List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
          icon: const Icon(Icons.shopping_basket, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                SlideFromLeftPageRoute(
                    widget: OrderScreen()
                )
            );
          }),
    ];
  }

  void _showDialogSuccess() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Thông báo"),
            content: new Text("Bạn có muốn tiếp tục đặt món"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Tiếp tục"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    Navigator.push(
                        context,
                        SlideFromLeftPageRoute(
                            widget: HomeScreen()
                        )
                    );
                  });
                },
              ),
              new FlatButton(
                child: new Text("Thanh toán"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    Navigator.push(
                        context,
                        SlideFromLeftPageRoute(
                            widget: OrderScreen()
                        )
                    );
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _createBody() {
    return SingleChildScrollView(
        child: Stack(children: <Widget>[
          new Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: foodInfo.image != null ? new NetworkImage(foodInfo.image) : new AssetImage("assets/food_default.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: <Color>[
                          const Color.fromRGBO(0, 0, 0, 0.5),
                          const Color.fromRGBO(51, 51, 63, 0.1),
                        ],
                        stops: [0.2, 1.0],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                      )))),
          new SafeArea(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                        padding: EdgeInsets.all(20),
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Expanded(
                                child: new Text(foodInfo.foodName != null ? foodInfo.foodName : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 45)),
                              ),
                              new Expanded(
                                  child: new Align(
                                    alignment: Alignment.topRight,
                                    child: new Text(
                                        FormatPrice.getFormatPrice(foodInfo.discountPrice != null ? foodInfo.discountPrice : "0"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30)),
                                  ),
                                  flex: 2),
                            ]))
                  ])),
          new Positioned(
              child: new Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: new Container(
                    //    height: 290.0,
                      child: Container(
                          margin: EdgeInsets.only(top: 330.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.0),
                                    topRight: Radius.circular(40.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.orange[100].withOpacity(0.3),
                                        offset: Offset(0.0, -10.0),
                                        blurRadius: 8.0)
                                  ]),
                              child: new Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                child:
                                Column(mainAxisSize: MainAxisSize.min, children: <
                                    Widget>[
                                  new Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 25, right: 25, bottom: 15),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                    ),
                                    child: new Text(
                                      'Lưu ý đặt biệt',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  new Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 15),
                                      decoration: BoxDecoration(color: Colors.white),
                                      child: new TextField(
                                          autofocus: false,
                                          decoration: const InputDecoration(
                                            hintText: 'Ví dụ: không rau.....',
                                            hintStyle:
                                            const TextStyle(color: Colors.grey),
                                          ),
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 16.0),
                                          onChanged: (String value) {
                                            note = value;
                                          })),
                                  new Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 15),
                                    decoration: BoxDecoration(color: Colors.white),
                                    child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Container(
                                              width: 40,
                                              height: 40,
                                              margin:
                                              const EdgeInsets.only(right: 20.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          229, 32, 32, 1.0),
                                                      width: 1.0)),
                                              child: new FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (intCount > 0) {
                                                        intCount = intCount - 1;
                                                      }
                                                    });
                                                  },
                                                  child: new Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                    color: Color.fromRGBO(
                                                        229, 32, 32, 1.0),
                                                  ),
                                                  color: Colors.white)),
                                          new Container(
                                              width: 30,
                                              height: 30,
                                              child: Center(
                                                child: new Text(
                                                  '$intCount',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          new Container(
                                              width: 40,
                                              height: 40,
                                              margin: const EdgeInsets.only(left: 20.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          229, 32, 32, 1.0),
                                                      width: 1.0)),
                                              child: new FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      intCount = intCount + 1;
                                                    });
                                                  },
                                                  child: new Icon(
                                                    Icons.add,
                                                    size: 15,
                                                    color: Color.fromRGBO(
                                                        229, 32, 32, 1.0),
                                                  ),
                                                  color: Colors.white)),
                                        ]),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLoading = true;
                                        _postOrder();
                                      });
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 20),
                                      decoration: BoxDecoration(color: Colors.white),
                                      child: new Container(
                                          width:
                                          MediaQuery.of(context).size.width * 0.8,
                                          height: 38.0,
                                          alignment: FractionalOffset.center,
                                          decoration: new BoxDecoration(
                                              color: intCount > 0
                                                  ? const Color.fromRGBO(
                                                  229, 32, 32, 1.0)
                                                  : Colors.grey,
                                              borderRadius: new BorderRadius.all(
                                                  const Radius.circular(5.0))),
                                          child: new Text("Thêm vào giỏ hàng",
                                              style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.3,
                                              ))),
                                    ),
                                  )
                                ]),
                              ))))
              )
          ),

        ]));
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
            iconTheme: new IconThemeData(color: Colors.white),
            title: Text("Chi tiết"),
            actions: _buildActions()),
        body: isLoading ? _createProgress() : _createBody()
    );
  }
}
