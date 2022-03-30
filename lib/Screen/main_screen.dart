// @dart=2.9
// ignore_for_file: deprecated_member_use, unnecessary_new
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manage/Interactive_data/Interactive_User.dart';
import 'package:manage/Interactive_data/google_SignIn.dart';
import 'package:manage/Model/UserModel.dart';
import 'package:manage/Screen/loginScreen.dart';
import 'package:manage/Ultils/Navigate.dart';

class mainScreen extends StatefulWidget {
  var title = null;

  supportSignInGoogle supportGoogle = null;
  GoogleSignIn googleSignIn = null;

  var userFromDB;
  mainScreen({
    Key key,
    this.title,
    this.supportGoogle,
    this.googleSignIn,
    this.userFromDB,
  }) : super(key: key);
  mainScreenState createState() => mainScreenState();
}

class mainScreenState extends State<mainScreen> {
  Navigate navi = Navigate();
  Interactive_User interUser = Interactive_User();
  Future<List<User>> listUser;
  List<User> listtest = new List<User>.empty(growable: true);
  var _currentUser;
  @override
  void initState() {
    listUser = interUser.getAllUser();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) 
  {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hi ' + widget.title),
        ),
        body:
        SafeArea(
            child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text('Log Out'),
                onPressed: () 
                {
                  if (widget.supportGoogle != null && widget.googleSignIn != null) 
                  {
                      widget.supportGoogle.handleSignOut(widget.googleSignIn);
                      widget.googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) 
                      {
                        setState(() 
                        {
                        _currentUser = account;
                          if (_currentUser == null) 
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Log out Success'),
                              duration: Duration(milliseconds: 1000),
                            ));
                            navi.PopnavigateToAnotherPage(context);
                            navi.PushnavigateToAnotherPage(
                                context, loginScreen());
                          }
                      });
                    });
                  }
                  if (widget.userFromDB != null) 
                  {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Log out Success'),
                      duration: Duration(milliseconds: 1000),
                    ));
                    navi.PopnavigateToAnotherPage(context);
                    navi.PushnavigateToAnotherPage(context, loginScreen());
                  }
                },
              ),
            ),
            SizedBox
            (
             height: 10, 
            ),
            FutureBuilder
            (
                future: listUser,
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                      {
                        return CircularProgressIndicator(color: Colors.cyanAccent);
                      }
                  else if (snapshot.connectionState == ConnectionState.done) 
                  {
                    return (Expanded(
                        child:
                          RefreshIndicator
                          (
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox
                                  (
                                    height: 5,
                                  ),
                                  GestureDetector
                                  (
                                    child: Column
                                    (
                                      children: [
                                        Container
                                        (
                                          alignment: Alignment.topLeft,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3.0))),
                                          child: Card(
                                            child: ListTile(
                                                title: Text(snapshot
                                                    .data[index].username),
                                                leading:  CircleAvatar(
                                                  
                                                  backgroundImage: AssetImage('assets/images/12693195.jpeg'),
                                                ),
                                                trailing: Icon(Icons.star)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => {
                                      
                                      setState(() {
                                        print(snapshot.data[index].id);
                                      })
                                    },
                                  )
                                ],
                              );
                            }), 
                            onRefresh:() async 
                            {
                              Future<List<User>> listResponse;
                              listResponse =  pullRefresh();
                              
                              listResponse.whenComplete(() => {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('done')))
                              }); 
                              setState(() {
                                listUser =  listResponse;
                              });
                            })));
                  } 
                  else 
                  {
                    return Container(
                     
                    );
                  }
                }),
          ],
        )),
          floatingActionButton: SpeedDial
          (
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.redAccent,
            overlayColor: Colors.grey,
            overlayOpacity: 0.5,
            spacing: 15,
            spaceBetweenChildren: 15,
            closeManually: false,
            visible: true,
            children: [
              SpeedDialChild(
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.green,
                onTap: () => {
                  navi.PushnavigateToAnotherPage(context, loginScreen())
                }, 
                label: 'Add',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                labelBackgroundColor: Colors.black,
              )
            ],
          )
        ,
          );
  }
}
Future<List<User>> pullRefresh() 
{
  Interactive_User inter = Interactive_User();
  var listRefreshUser =   inter.getAllUser();
  return listRefreshUser;
}
