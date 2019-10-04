import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/Login.dart';
import 'package:uit_cantin/pages/Home.dart';

void main() {
  runApp(MaterialApp(
    title: 'UIT Canteen App',
    initialRoute: '/',
    routes: {
      '/': (context) => LoginScreen(),
      '/home': (context) => HomeScreen(),
    },
  ));
}
