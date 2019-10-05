import "package:flutter/material.dart";
import 'package:uit_cantin/compoments/LoaderColor.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return           new Container(
      alignment: AlignmentDirectional.center,
      decoration: new BoxDecoration(
        color: Colors.white70,
      ),
      child: new Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(10.0)
        ),
        width: 270.0,
        height: 120.0,
        alignment: AlignmentDirectional.center,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new LoaderColor(radius: 15.0, dotRadius: 6.0)
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: new Center(
                child: new Text(
                  "Loading....",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 18.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}