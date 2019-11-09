import 'package:uit_cantin/models/Notification.dart';
import 'package:flutter/material.dart';

var intCount = 0;

class NotificationWidget extends StatefulWidget {
  final NotificationInfo info;

  NotificationWidget({Key key, this.info}) : super(key: key);

  @override
  _Notification createState() => _Notification();
}

class _Notification extends State<NotificationWidget> {
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
        /*onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ItemDetails(food: food)));
        },*/
        child: new Container(
            child: new Row(
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.height * 0.1,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: new NetworkImage(widget.info.image),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            border: new Border.all(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(left: 15.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                child: new Text(widget.info.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0)),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 3.0),
                child: new Text(widget.info.subTitle,
                    style: TextStyle(color: Colors.grey, fontSize: 17.0)),
              )
            ],
          ),
        )
      ],
    )));
  }
}
