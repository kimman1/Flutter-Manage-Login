 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Screen/CafeManagerScreen.dart';
import 'package:manage/Ultils/Navigate.dart';

class DialogCreate{

  void dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }
 void showMaterialDialog(BuildContext context, String Title, String Content) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            
            child: AlertDialog(
              alignment: Alignment.center,
            title: Text(Title),
            content: Text(Content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    dismissDialog(context);
                  },
                  child: Text('Close')),
            ],
          ));
        });
  }
void showMaterialDialogWithWidget(BuildContext context, String Title, String Content, Widget widget) {
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
                    Navigate navi = Navigate();
                    //navi.PopnavigateToAnotherPage(context);
                    //navi.popUntilWithName(context,'loginScreen');
                   navi.PopnavigateToAnotherPage(context);
                   navi.PopnavigateToAnotherPage(context);
                    navi.PushnavigateToAnotherPage(context, widget);
                  },
                  child: Text('Close')),
            ],
          );
        });
  }
  void showMaterialDialogWithDeleteTemplate(BuildContext context, List<String> listID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notice'),
            content: const Text('Delete ?'),
            actions: <Widget>[
              TextButton
              (
                onPressed: () async
                {
                  InteractiveCategory inter = InteractiveCategory();
                  showMaterialDialog(context, "On Process", "Please waiting... \nDon't press close if more than 10s");
                  
                      List<JsonReturnModel> listJsonReturn = await inter.deleteCategory(listID);
                      dismissDialog(context);
                      if(listJsonReturn.isNotEmpty)
                      {
                        String contentDialog = "";
                        for(JsonReturnModel i in listJsonReturn)
                        {
                            contentDialog += "Status Code: "  + i.statusCode + '\n' + "Result: " +  i.message + '\n';
                        }
                        showMaterialDialogWithWidget(context, "Notice", contentDialog, CafeManagerScreen() );
                      }
                      else
                      {
                        showMaterialDialog(context, "Notice", "Please contact administrator");
                      }
                }, 
                child: Text('Delete'),
              ),
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