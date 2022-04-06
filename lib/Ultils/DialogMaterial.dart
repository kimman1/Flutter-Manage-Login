 import 'package:flutter/material.dart';

class DialogCreate{

  void dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }
 void showMaterialDialog(BuildContext context, String Title, String Content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Title),
            content: Text(Content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    dismissDialog(context);
                  },
                  child: Text('Close')),
            ],
          );
        });
  }
  }