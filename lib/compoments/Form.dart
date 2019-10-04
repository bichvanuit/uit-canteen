import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.only(bottom: 200.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new TextField(
                decoration: InputDecoration(
                  labelText: "Mã số sinh viên",
                  labelStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.person_outline, color: Colors.white),
                )
              ),
              new TextField(
                decoration: InputDecoration(
                labelText: "Mật khẩu",

                labelStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.lock_outline, color: Colors.white),
                )
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
