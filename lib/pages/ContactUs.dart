import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUs createState() => _ContactUs();
}

class _ContactUs extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Gọi cho chúng tôi"),
              content: new Text("Call 0352107018"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Gọi"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          //  title: appBarTitle,
          iconTheme: new IconThemeData(color: Colors.white),
          //  leading: _isSearching ? const BackButton() : null,
          title: Text("Liên hệ với chúng tôi"),
        ),
        body: new Container(
            padding: new EdgeInsets.all(25.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 200.0,
                  width: 200.0,
                  child: new Image.asset('assets/call-center.png'),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      "Chúng tôi rất vui nhận được ý kiến phản hồi từ bạn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    color: Color.fromRGBO(229, 32, 32, 1.0),
                    onPressed: _showDialog,
                    child: Text(
                      "Gọi ngay cho chúng tôi".toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )));
  }
}
