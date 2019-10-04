import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:uit_cantin/compoments/WhiteTick.dart';
import 'package:uit_cantin/models/User.dart';
import 'package:uit_cantin/services/Token.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  User userInfo = new User();
  var animationStatus = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controllerUsername = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<Null> _playAnimation() async {

    userInfo.username = _controllerUsername.text;
    userInfo.password = _controllerPassword.text;
    var url = '$SERVER_NAME/login';
    var response = await http.post(url, body: userInfo.toMap());
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      if (status == STATUS_SUCCESS) {
        Token token = new Token();
        await token.setMobileToken(responseBody["data"]);
        try {
          await _loginButtonController.forward();
          await _loginButtonController.reverse();
        } on TickerCanceled {}
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

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
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
                              new Tick(image: tick),
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
                                margin:
                                    new EdgeInsets.symmetric(horizontal: 20.0),
                                padding: const EdgeInsets.only(bottom: 200.0),
                                child: new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Form(
                                      key: _formKey,
                                        child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        new TextFormField(
                                            controller: _controllerUsername,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              labelText: "Mã số sinh viên",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              icon: Icon(Icons.person_outline,
                                                  color: Colors.white),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 0.0),
                                              ),
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty)
                                                return "Bạn chưa nhập mã số sinh viên";
                                              return null;
                                            }
                                        ),
                                        new Container(
                                          margin:
                                              const EdgeInsets.only(top: 8.0),
                                        ),
                                        new TextFormField(
                                            controller: _controllerPassword,
                                            style:
                                                TextStyle(color: Colors.white),
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              labelText: "Mật khẩu",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              icon: Icon(Icons.lock_outline,
                                                  color: Colors.white),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 0.0),
                                              )
                                            ),
                                          validator: (String value) {
                                            if (value.isEmpty)
                                              return "Bạn chưa nhập mật khẩu";
                                            return null;
                                          }
                                        )
                                      ]
                                    ))
                                  ]
                                )
                              )
                            ]
                          ),
                          animationStatus == 0
                              ? new Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: new InkWell(
                                      onTap: () {
                                       /* if (_formKey.currentState.validate()) {
                                          setState(() {
                                            animationStatus = 1;
                                            //  animationStatus = 1;

                                          });
                                          _playAnimation();
                                        }*/
                                        setState(() {
                                          animationStatus = 1;
                                          //  animationStatus = 1;

                                        });
                                        _playAnimation();
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
                                )
                              : new StaggerAnimation(
                                  buttonController:
                                      _loginButtonController.view),
                        ],
                      ),
                    ],
                  ))),
        )));
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        buttomZoomOut = new Tween(
          begin: 70.0,
          end: 1000.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: new InkWell(
          onTap: () {
            _playAnimation();
          },
          child: new Hero(
            tag: "fade",
            child: buttomZoomOut.value <= 300
                ? new Container(
                    width: buttomZoomOut.value == 70
                        ? buttonSqueezeanimation.value
                        : buttomZoomOut.value,
                    height:
                        buttomZoomOut.value == 70 ? 60.0 : buttomZoomOut.value,
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      color: const Color.fromRGBO(247, 64, 106, 1.0),
                      borderRadius: buttomZoomOut.value < 400
                          ? new BorderRadius.all(const Radius.circular(30.0))
                          : new BorderRadius.all(const Radius.circular(0.0)),
                    ),
                    child: buttonSqueezeanimation.value > 75.0
                        ? new Text(
                            "Đăng nhập",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          )
                        : buttomZoomOut.value < 300.0
                            ? new CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : null)
                : new Container(
                    width: buttomZoomOut.value,
                    height: buttomZoomOut.value,
                    decoration: new BoxDecoration(
                      shape: buttomZoomOut.value < 500
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      color: const Color.fromRGBO(247, 64, 106, 1.0),
                    ),
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushNamed(context, "/home");
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}

DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/rice.jpg'),
  fit: BoxFit.cover,
);

DecorationImage tick = new DecorationImage(
  image: new ExactAssetImage('assets/fork.png'),
  fit: BoxFit.cover,
);
