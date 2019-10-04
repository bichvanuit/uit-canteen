import 'package:flutter/material.dart';
import 'package:uit_cantin/models/FoodInfo.dart';

class IngredientWidget extends StatefulWidget {
  final FoodInfo food;

  IngredientWidget({Key key, this.food}) : super(key:key);
  _IngredientWidget createState() => _IngredientWidget();

}

class _IngredientWidget extends State<IngredientWidget> {

  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  new Text(widget.food.foodName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                  new Text("${widget.food.discountPrice}")
              ]
          ),
          new Column(
              children: <Widget>[
                new Row(
                    children: <Widget>[
                      new SizedBox(
                          width: 40,
                          height: 40,
                          child:
                          new FlatButton(
                              onPressed: (){
                              },
                              child: new Icon(Icons.remove, size: 15, color: Colors.white),
                              color: const Color.fromRGBO(229, 32, 32, 1.0)
                          )
                      ),
                      new Container(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: new Text(
                            "0",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ),
                      new SizedBox(
                          width: 40,
                          height: 40,
                          child: new FlatButton(
                              onPressed: () async {
                              },
                              child: new Icon(Icons.add, size: 15, color: Colors.white),
                              color: const Color.fromRGBO(229, 32, 32, 1.0)
                          )
                      )
                    ]
                )
              ]
          )
        ]
    );
  }
}