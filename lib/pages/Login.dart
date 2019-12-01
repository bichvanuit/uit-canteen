import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:uit_cantin/compoments/WhiteTick.dart';
import 'package:uit_cantin/models/User.dart';
import 'package:uit_cantin/services/Token.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  User userInfo = new User();
  final TextEditingController _controllerUsername = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new Scaffold(
        body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  Future<Null> _login() async {
    userInfo.username = _controllerUsername.text;
    userInfo.password = _controllerPassword.text;
    var url = '$SERVER_NAME/login';
    var response = await http.post(url, body: userInfo.toMap());
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      isLoading = false;
      if (status == STATUS_SUCCESS) {
        Token token = new Token();
        await token.setMobileToken(responseBody["data"]);
        Navigator.pushNamed(context, "/home");
      } else {
        _showDialog();
      }
    }
  }

  void _showDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Sai mã số sinh viên hoặc mật khẩu"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Thử lại"),
                onPressed: () {
                  setState(() {
                    isLoading = false;
                  });
                  _controllerUsername.clear();
                  _controllerPassword.clear();
                  Navigator.of(context).pop();

                },
              ),
              new FlatButton(
                child: new Text("Thoát ứng dụng"),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          );
        });
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Are you sure?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _createBody() {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new ExactAssetImage('assets/uit.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: <Color>[
                        const Color.fromRGBO(0, 0, 0, 0.5),
                        const Color.fromRGBO(51, 51, 63, 0.9),
                      ],
                      stops: [0.2, 1.0],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 1.0),
                    ),
                  ),
                  child: new ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Tick(image: new DecorationImage(
                                  image: new ExactAssetImage('assets/fork.png'),
                                  fit: BoxFit.cover,
                                )),
                                new Container(
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  child: new Text("UIT Căn tin",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 50.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                new Container(
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    padding:
                                    const EdgeInsets.only(bottom: 200.0),
                                    child: new Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                        new Form(
                                              key: _formKey,
                                              child: new Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                                  children: <Widget>[
                                                    new TextFormField(
                                                        controller:
                                                        _controllerUsername,
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white),
                                                        decoration:
                                                        InputDecoration(
                                                          labelText:
                                                          "Mã số sinh viên",
                                                          labelStyle: TextStyle(
                                                              color:
                                                              Colors.white),
                                                          icon: Icon(
                                                              Icons
                                                                  .person_outline,
                                                              color:
                                                              Colors.white),
                                                          enabledBorder:
                                                          const UnderlineInputBorder(
                                                            borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.0),
                                                          ),
                                                        ),
                                                        validator:
                                                            (String value) {
                                                          if (value.isEmpty)
                                                            return "Bạn chưa nhập mã số sinh viên";
                                                          return null;
                                                        }),
                                                    new Container(
                                                      margin:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                    ),
                                                    new TextFormField(
                                                        controller:
                                                        _controllerPassword,
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white),
                                                        obscureText: true,
                                                        decoration:
                                                        InputDecoration(
                                                            labelText:
                                                            "Mật khẩu",
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            icon: Icon(
                                                                Icons
                                                                    .lock_outline,
                                                                color: Colors
                                                                    .white),
                                                            enabledBorder:
                                                            const UnderlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width:
                                                                  0.0),
                                                            )),
                                                        validator:
                                                            (String value) {
                                                          if (value.isEmpty)
                                                            return "Bạn chưa nhập mật khẩu";
                                                          return null;
                                                        })
                                                  ]))
                                        ]))
                              ]),
                          new Positioned(
                            child: new Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: new Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: new InkWell(
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            isLoading = true;
                                            _login();
                                          });
                                        }
                                      },
                                      child: new Container(
                                        width: 320.0,
                                        height: 60.0,
                                        alignment: FractionalOffset.center,
                                        decoration: new BoxDecoration(
                                          color: const Color.fromRGBO(
                                              229, 32, 32, 1.0),
                                          borderRadius: new BorderRadius.all(
                                              const Radius.circular(30.0)),
                                        ),
                                        child: new Text(
                                          "Đăng nhập",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      )),
                                )),
                          )
                        ],
                      ),
                    ],
                  ))),
        ));
  }

  Widget _createProgress() {
    return new Container(
      child: new Stack(
        children: <Widget>[_createBody(), new LoadingWidget()],
      ),
    );
  }
}
