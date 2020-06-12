import 'package:flutter/material.dart';

class TransitionPageRoute extends PageRouteBuilder {
  final Widget widget;
  final Alignment alignment;
  final Curve curve;
  final Duration duration;

  TransitionPageRoute({this.widget, this.alignment, this.curve, this.duration})
      : super(
            transitionDuration: duration,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(parent: animation, curve: curve);

              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: alignment,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
