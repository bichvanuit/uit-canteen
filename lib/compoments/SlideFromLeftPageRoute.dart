import 'package:flutter/material.dart';

class SlideFromLeftPageRoute extends PageRouteBuilder {
  Widget widget;

  SlideFromLeftPageRoute({this.widget}) : super(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (c, anim, a2, child) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      transitionDuration: Duration(milliseconds: 1000),
  );
}