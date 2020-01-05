import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:uit_cantin/models/User.dart';
import 'package:uit_cantin/services/Token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';
import 'package:uit_cantin/compoments/LoadingWidget.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:uit_cantin/pages/RequireNumberPhone.dart';
import 'package:device_info/device_info.dart';
import 'package:uit_cantin/models/UserInfo.dart';
import 'package:uit_cantin/pages/OTPNewDevice.dart';
import 'package:uit_cantin/pages/Home.dart';
import 'package:uit_cantin/compoments/SlideFromLeftPageRoute.dart';

Future<UserInfo> _fetchUserInfo() async {
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

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  YYDialog _showDialog(BuildContext context) {
    return YYDialog().build(context)
      ..width = 230
      ..borderRadius = 4.0
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: "Sai mã số sinh viên hoặc mật khẩu",
        color: Colors.black,
        fontSize: 17.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "Thoát ứng dụng",
        color1: Colors.redAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        text2: "Thử lại",
        color2: Colors.redAccent,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          setState(() {
            isLoading = false;
          });
          _controllerUsername.clear();
          _controllerPassword.clear();
        },
      )
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new Scaffold(
      body: isLoading == true ? _createProgress() : _createBody(),
    );
  }

  _newDevice() async {
    setState(() {
      isLoading = true;
    });
    var url = '$SERVER_NAME/user/verify-device';

    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var response = await http.post(url, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
      var status = responseBody["status"];
      Navigator.of(context).pop();
      Navigator.push(
          context, SlideFromLeftPageRoute(widget: OTPNewDeviceScreen()));
    }
  }

  _loginUser() async {
    var devideId = await _getId();
    userInfo.username = _controllerUsername.text;
    userInfo.password = _controllerPassword.text;
    userInfo.deviceId = devideId;
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
//        Navigator.push(context, SlideFromLeftPageRoute(widget: HomeScreen()));
        UserInfo user = await _fetchUserInfo();
        if (user.phone == null) {
          Navigator.push(context,
              SlideFromLeftPageRoute(widget: RequireNumberPhoneScreen()));
        } else if (user.newDevice) {
          _newDevice();
        } else {
          Navigator.push(context, SlideFromLeftPageRoute(widget: HomeScreen()));
        }
      } else {
        _showDialog(context);
      }
    }
  }

  _loginRep() async {
    var requestBody = new Map<String, dynamic>();
    requestBody["username"] = _controllerUsername.text;
    requestBody["password"] = _controllerPassword.text;

    var url = '$SERVER_NAME/login-receptionist';
    var response = await http.post(url, body: requestBody);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      isLoading = false;
      if (status == STATUS_SUCCESS) {
        Token token = new Token();
        await token.setMobileToken(responseBody["data"]);
        Navigator.push(context, SlideFromLeftPageRoute(widget: HomeScreen()));
      } else {
        _showDialog(context);
      }
    }
  }

  _login()  {
    print(_controllerUsername.text);
    if (_controllerUsername.text.contains('rep.') ) {
      _loginRep();
    } else {
      _loginUser();
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Bạn có chắc chắn muốn thoát khỏi ứng dụng'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Không'),
              ),
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Thoát ứng dụng'),
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
                  image: new NetworkImage(
                      'https://toinayangi.vn/wp-content/uploads/2016/05/C%C3%A1ch-l%C3%A0m-c%C6%A1m-chi%C3%AAn-th%E1%BB%8Bt-g%C3%A0-quay-%C4%91%C6%A1n-gi%E1%BA%A3n1.jpg'),
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
                                new Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      0, 100.0, 0, 15.0),
                                  width: 100.0,
                                  height: 100.0,
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                    image: DecorationImage(
                                      image: new ExactAssetImage(
                                          'assets/fork.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
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
