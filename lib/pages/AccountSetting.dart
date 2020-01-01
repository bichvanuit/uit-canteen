import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:uit_cantin/pages/User.dart';

class AccountSettingScreen extends StatefulWidget {
  final String fullName;

  AccountSettingScreen({Key key, this.fullName}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSettingScreen> {
  TextEditingController _textFieldController = TextEditingController();
  bool isLoading = false;

  _editFullname() async {
    var url = '$SERVER_NAME/user/edit-fullname';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, String>();
    requestBody["fullname"] = _textFieldController.text;

    var response =
        await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        setState(() {
          isLoading = true;
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => new UserScreen(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 2000),
            ),
          );
        });
      } else {}
    }
  }

  _showModalEditFullname() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return new SingleChildScrollView(
            child: new Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: Color(0xFFC0C0C0),
              ),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(color: Colors.white),
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: new Text(
                      "Cập nhật họ tên",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      decoration: BoxDecoration(color: Colors.white),
                      child: new TextField(
                        controller: _textFieldController,
                        autofocus: false,
                        decoration: const InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText: 'Nhập họ và tên....'),
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      )),
                  new Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: CanteenAppTheme.main,
                            child: Text("Hủy bỏ"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: CanteenAppTheme.main,
                            child: Text("Cập nhật"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                isLoading = true;
                                _editFullname();
                              });
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Thông tin tài khoản"),
        ),
        body: isLoading ? _createProgress() : _createBody());
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }

  Widget _createBody() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Tên tài khoản',
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(widget.fullName),
          onTap: _showModalEditFullname,
        )
      ],
    );
  }
}
