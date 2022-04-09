// @dart=2.9
// ignore_for_file: unnecessary_new, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manage/Interactive_data/google_SignIn.dart';
import 'package:manage/Screen/CafeManagerScreen.dart';
import 'package:manage/Screen/main_screen.dart';
import 'package:manage/Ultils/Navigate.dart';
import 'package:swipe_to/swipe_to.dart';

class SelectionScreen extends StatefulWidget
{
  supportSignInGoogle supportGoogle = null;
  GoogleSignIn googleSignIn = null;
  var userFromDB;
  String tilte = "";
  SelectionScreen({Key key,
  this.supportGoogle,
  this.googleSignIn,
  this.userFromDB,
  this.tilte,
  }) : super(key: key);

  SelectionScreenState createState() => SelectionScreenState();
}
class SelectionScreenState extends State<SelectionScreen>
{
  Navigate navi = Navigate();
   List<String> listSelection = new List<String>();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      listSelection.addAll(["User Manager", "Cafe Manager", "Schedule Manager"]);      
    });
    
  }
  Widget build(BuildContext context)
  {
      return WillPopScope(
        onWillPop: () {
          navi.PopnavigateToAnotherPage(context);
          widget.userFromDB = null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out')));
        },
        child: Scaffold(
        appBar:  AppBar(
          title: Text('Selection Screen'),
        ),
        body: SafeArea
        (
          child: Container
          (
            child: Row
            (
              children: [
                      Expanded(
                      child: ListView.builder
                        (
                        itemCount: listSelection.length ,
                        itemBuilder:  ( context, index) 
                      {
                          return (
                            
                               Card
                            (
                              child:
                              SwipeTo
                              (
                                onRightSwipe: ()
                                {
                                     String result = listSelection[index].toString();
                                      if(result == "User Manager")
                                      {
                                        navi.PushnavigateToAnotherPage(context, mainScreen(title: widget.tilte,googleSignIn: widget.googleSignIn, supportGoogle: widget.supportGoogle,userFromDB: widget.userFromDB,));
                                      }
                                      else if(result == "Cafe Manager")
                                      {
                                        navi.PushnavigateToAnotherPage(context, CafeManagerScreen());
                                      }
                                      else if(result == "Schedule Manager")
                                      {
                                        print('not done yet');
                                        
                                      }
                                },
                                child: ListTile(
                                title:  Text(listSelection[index],),
                                leading: Icon(Icons.currency_bitcoin),
                            ),
                              )
                              
                              )
                        );
                      }
                    )
                ),

              ],
            )

            
      ))),
      );
  }
}