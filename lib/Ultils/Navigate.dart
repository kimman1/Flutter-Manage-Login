import 'package:flutter/material.dart';

class Navigate {
  void PushnavigateToAnotherPage(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  void PopnavigateToAnotherPage(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  void popUntil(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  void popUntilWithName(BuildContext context, String ScreenName) {
    Navigator.popUntil(context, ModalRoute.withName('/$ScreenName'));
  }
  
}
