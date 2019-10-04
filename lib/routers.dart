import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/Login.dart';
import 'package:uit_cantin/pages/Home.dart';
import 'package:uit_cantin/pages/Menu.dart';

class Routes {
  Routes() {
    runApp(new MaterialApp(
      title: "UIT Canteen App",
      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );

          case '/home':
            return new MyCustomRoute(
              builder: (_) => new HomeScreen(),
              settings: settings,
            );
          case '/menu':
            return new MyCustomRoute(
              builder: (_) => new MenuScreen(),
              settings: settings,
            );
        }
        return null;
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
