import 'package:flutter/material.dart';
import 'package:sheet/route.dart';

class MyRouter {
  static Future pushPage(BuildContext context, Widget page) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => page,
        ),
      );
  static Future pushRoute(BuildContext context, Widget widget) =>
      Navigator.push(context,
          CupertinoSheetRoute(builder: (BuildContext context) => widget));

  static Future pushPageDialog(BuildContext context, Widget page) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => page,
          fullscreenDialog: true,
        ),
      );

  static Future pushPageReplacement(BuildContext context, Widget page) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => page,
        ),
      );
}
