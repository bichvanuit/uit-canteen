import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodInfo.dart';

class OrderDetailScreen extends StatefulWidget {
  final FoodInfo food;

  OrderDetailScreen({Key key, this.food}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

List<String> listOrder = <String> [
  'https://banhmro.com.vn/wp-content/uploads/2017/02/cach-lam-trung-op-la-ngon-dep-va-don-gian-an-voi-banh-mi.jpg',
  'https://banhmro.com.vn/wp-content/uploads/2017/02/cach-lam-trung-op-la-ngon-dep-va-don-gian-an-voi-banh-mi.jpg',
  'https://banhmro.com.vn/wp-content/uploads/2017/02/cach-lam-trung-op-la-ngon-dep-va-don-gian-an-voi-banh-mi.jpg'
];

class _OrderDetailState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new NetworkImage(widget.food.image),
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
            new Column(
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: new BoxDecoration(
                    color: Color.fromRGBO(229, 32, 32, 1.0),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                  ),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(widget.food.foodName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40))),
                      new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height * 0.1,
                                    bottom: 5.0),
                                child: new Text(widget.food.discountPrice,
                                    style:
                                    TextStyle(fontSize: 17.0, color: Colors.white)),
                              ),
                              new Row(children: <Widget>[
                                new SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: new FlatButton(
                                      onPressed: () {},
                                      child: new Icon(Icons.remove,
                                          size: 15, color: Colors.black),
                                      color: Colors.white,
                                    )),
                                new Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: new Text(
                                        "0",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    )),
                                new SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: new FlatButton(
                                        onPressed: () async {},
                                        child: new Icon(Icons.add,
                                            size: 15, color: Colors.black),
                                        color: Colors.white))
                              ])
                            ],
                          ))
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                  height: MediaQuery.of(context).size.height*0.1,
                  child: new ListView.builder(
                      itemCount: listOrder.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, position) {
                        return Container(
                            padding: EdgeInsets.only(right: 10),
                            child: new GestureDetector(
                                onTap: (){

                                },
                                child: new Container(
                                  width: MediaQuery.of(context).size.height*0.1,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  decoration: new BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: new DecorationImage(
                                      image: new NetworkImage(listOrder[position]),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                                    border: new Border.all(
                                      color: Color.fromRGBO(229, 32, 32, 1.0),
                                      width: 4.0,
                                    ),
                                  ),
                                )
                            )
                        );
                      }),
                ),
                new Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.5),
                  child: new GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => new OrderDetailScreen(food: widget.food),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 2000),
                            ),
                          );
                        });
                      },
                      child: new Container(
                          width: MediaQuery.of(context).size.width *
                              0.8,
                          height: 38.0,
                          alignment: FractionalOffset.center,
                          margin: const EdgeInsets.only(top: 2.0),
                          decoration: new BoxDecoration(
                              color: const Color.fromRGBO(
                                  229, 32, 32, 1.0),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(5.0))),
                          child: new Text("OK",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.3,
                              )))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
