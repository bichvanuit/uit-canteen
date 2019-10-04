import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountSettingScreen extends StatefulWidget {
  final String fullName;
  AccountSettingScreen({Key key, this.fullName}) : super(key: key);
  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSettingScreen> {
  bool _value1 = false;
  void _onChanged1(bool value) {
    var alert = new CupertinoAlertDialog(
      title: new Text("Cảnh báo"),
      content: new Text("Bạn có muốn tiếp tục ?"),
      actions: <Widget>[
        new CupertinoDialogAction(
            child: const Text('Có'),
            isDestructiveAction: true,
            onPressed: () { Navigator.pop(context, 'Có'); }
        ),
        new CupertinoDialogAction(
            child: const Text('Không'),
            isDefaultAction: true,
            onPressed: () { Navigator.pop(context, 'Không'); }
        ),
      ],
    );
    showDialog(context: context, child: alert);
  }

  void _showModalEditFullname() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return new SingleChildScrollView(
            child: new Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: Color(0xFFC0C0C0),
              ),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      decoration: BoxDecoration(color: Colors.white),
                      child: new TextField(
                        //    controller: _searchQuery,
                        autofocus: false,
                        decoration: const InputDecoration(
                          hintText: 'Ví dụ: không rau.....',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                        //   onChanged: updateSearchQuery,
                      )),
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 150.0, right: 0.0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.black,
                            child: Text("Hủy bỏ"),
                            onPressed: () {},
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 150.0, right: 0.0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.black,
                            child: Text("Cập nhật"),
                            onPressed: () {},
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
        //  title: appBarTitle,
        iconTheme: new IconThemeData(color: Colors.white),
        //  leading: _isSearching ? const BackButton() : null,
        title: Text("Thông tin tài khoản"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Tên tài khoản', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(widget.fullName),
            onTap: _showModalEditFullname,
          ),
          ListTile(
            title: Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: new Switch(value: _value1, onChanged: _onChanged1),
          ),
          ListTile(
            title: Text('Ngôn ngũ', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}