import 'package:flutter/material.dart';

class Tick extends StatelessWidget {
  final DecorationImage image;
  Tick({this.image});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: const EdgeInsets.fromLTRB(0, 100.0, 0, 15.0),
      width: 100.0,
      height: 100.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: image,
      ),
    ));
  }
}
