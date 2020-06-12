//class CommonAppBar extends AppBar {
//  CommonAppBar({
//    @required this.appBarTitle,
//    @required this.onPressed,
//    @required this.showBackButton,
//  });
//
//  final String appBarTitle;
//  final Function onPressed;
//  final bool showBackButton;
//
//  Widget build() {
//    return AppBar(
//      elevation: 5.0,
//      backgroundColor: kPrimaryColor,
//      automaticallyImplyLeading: false,
//      centerTitle: false,
//      titleSpacing: 0,
//      title: Text(appBarTitle),
//      leading: showBackButton
//          ? IconButton(
//              icon: Icon(Icons.arrow_back_ios),
//              onPressed: onPressed,
//            )
//          : null,
//    );
//  }
//}

import 'package:flutter/material.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key key, Widget title, Widget leading})
      : super(
            key: key,
            title: title,
            leading: leading,
            automaticallyImplyLeading: false,
            centerTitle: false,);
}
