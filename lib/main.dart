import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/Login.dart';
import 'package:uit_cantin/pages/Home.dart';
import 'package:uit_cantin/portraitModeMixin.dart';
import 'package:uit_cantin/connectionStatus.dart';

void main() {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(App());
}
/// Main App widget
class App extends StatelessWidget with PortraitModeMixin {
  const App();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      title: 'UIT Canteen App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
