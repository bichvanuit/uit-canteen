import 'package:uit_cantin/models/FoodInfo.dart';
import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/ItemDetails.dart';

var intCount = 0;
class ItemFoodWidget extends StatefulWidget {
  final FoodInfo food;

  ItemFoodWidget({Key key, this.food}) : super(key: key);

  @override
  _ItemFoodWidget createState() => _ItemFoodWidget();
}

class _ItemFoodWidget extends State<ItemFoodWidget> {

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    intCount = 1;
    super.dispose();
  }

  void work() async {
    setState(() {
      intCount += 1;
    });
  }

  final double heightContainer = 220;
  final double widthContainer = 170;


  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ItemDetails(food: widget.food)));
        },
        child: new Container(
            child: new Row(
          children: <Widget>[
            new Expanded(
                flex: 1,
                child: new Stack(children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.height * 0.1,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: new DecorationImage(
                        image: new NetworkImage(widget.food.image),
                        fit: BoxFit.cover,
                      ),
                      border: new Border.all(
                        color: Color.fromRGBO(229, 32, 32, 1.0),
                        width: 1.0,
                      ),
                    ),
                  )
                ])),
            new Expanded(
              flex: 2,
              child: new Container(
                child: new Text(widget.food.foodName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new Container(
                alignment: Alignment.centerRight,
                child: new Text(widget.food.discountPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        )));
  }
}
