import 'package:flutter/material.dart';
import 'package:diagonal/diagonal.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:uit_cantin/pages/AccountSetting.dart';
import 'package:uit_cantin/pages/ContactUs.dart';
import 'package:uit_cantin/pages/AppInfo.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/services/Token.dart';
import 'package:uit_cantin/pages/Login.dart';
import 'package:image/image.dart' as ImageProcess;

Future<UserInfo>_fetchUserInfo() async {
  Token token = new Token();
  final tokenValue = await token.getMobileToken();
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer " + tokenValue,
  };
  final response = await http.get('$SERVER_NAME/user/get-detail-user',
      headers: requestHeaders);
  final parsed = json.decode(response.body)["data"];
  return UserInfo.fromJson(parsed);
}

class UserScreen extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserScreen> {
  File _image;

  _getImage(flag) async {
    var image;
    if (flag == 1) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    final _imageFile = ImageProcess.decodeImage(
      image.readAsBytesSync(),
    );

    String base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
    print(base64Image);
    Navigator.of(context).pop();

//    setState(() async {
//      _image = image;
//
//      String base64Image = base64Encode(image.readAsBytesSync());
//
//      var url = '$SERVER_NAME/user/edit-avatar';
//      Token token = new Token();
//      final tokenValue = await token.getMobileToken();
//      Map<String, String> requestHeaders = {
//        "Authorization": "Bearer " + tokenValue,
//      };
//
//      var requestBody = new Map<String, dynamic>();
//      requestBody["image"] = base64Image;
//
//      var response =
//      await http.post(url, body: requestBody, headers: requestHeaders);
//      var statusCode = response.statusCode;
//      print(statusCode);
//      if (statusCode == STATUS_CODE_SUCCESS) {
//        var responseBody = json.decode(response.body);
//        print(responseBody);
//      }
//    });
  }

  void _showDialogEditAvatar() {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0),
        height: 120.0,
        width: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                _getImage(1);
              },
              child: new Container(
                padding: const EdgeInsets.all(10),
                child: new Text(
                  "Chụp ảnh mới",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            new GestureDetector(
                onTap: () {
                  _getImage(2);
                },
                child: new Container(
                  padding: const EdgeInsets.all(10),
                  child: new Text(
                    "Chọn ảnh từ thư viện",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context)  {
            return AlertDialog(
              title: new Text("Bạn có muốn thoát khỏi tài khoản?"),
           //   content: new Text("Call 0352107018"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Có"),
                  onPressed: () async {
                    Token token = new Token();
                    await token.removeMobileToken();
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => new LoginScreen(),
                        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 2000),
                      ),
                    );
                  },
                ),
                new FlatButton(
                  child: new Text("Không"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }

    return new Scaffold(
      body: FutureBuilder<UserInfo>(
        future: _fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserInfo userInfo = snapshot.data;
            return new Column(
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    new Container(
                      height: 250.0,
                      child: Diagonal(
                        child: new Container(
                          color: const Color.fromRGBO(229, 32, 32, 1.0),
                        ),
                        clipHeight: 90.0,
                      ),
                    ),
                    new GestureDetector(
                      onTap: () {
                        _showDialogEditAvatar();
                      } ,
                      child: new Container(
                        margin: const EdgeInsets.only(top: 155.0),
                        child: new Container(
                            alignment: Alignment.center,
                            child: new Stack(
                              children: <Widget>[
                                new Container(
                                  height: 120,
                                  width: 120,
                                  child: ClipOval(
                                      child: Image.network(
                                        userInfo.avatar,
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.white,
                                      width: 5.0,
                                    ),
                                  ),
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(left: 90, top: 65),
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.grey,
                                      height: 30, // height of the button
                                      width: 30, // width of the button
                                      child: Center(
                                          child: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                            size: 20.0,
                                          )),
                                    ),
                                  ),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.white,
                                      width: 5.0,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  ],
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 7.0),
                  alignment: Alignment.center,
                  child: new Text(
                    userInfo.fullName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
                  ),
                ),
                new Container(
                  alignment: Alignment.bottomCenter,
                  height: 250.0,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text('Thiết lập tài khoản',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => new AccountSettingScreen(fullName: userInfo.fullName),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 2000),
                              ),
                            );
                          });
                        },
                      ),
                      ListTile(
                        title: Text('Thông tin app',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppInfoScreen()));
                          });
                        },
                      ),
                      ListTile(
                        title: Text('Liên hệ với chúng tôi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUsScreen()));
                          });
                        },
                      ),
                      ListTile(
                          title: Text('Đăng xuất',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: _showDialog
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return new Container();
        },
      ),
    );
  }
}
