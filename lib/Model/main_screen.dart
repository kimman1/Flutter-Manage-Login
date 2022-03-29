// @dart=2.9
// ignore_for_file: deprecated_member_use, unnecessary_new

import 'dart:async';

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
  mainScreen({
    Key key,
    this.title,
    this.supportGoogle,
    this.googleSignIn,
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hi ' + widget.title),
        ),
        body: SafeArea(
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
                onPressed: () {
                  if (widget.supportGoogle != null &&
                      widget.googleSignIn != null) {
                    widget.supportGoogle.handleSignOut(widget.googleSignIn);
                    widget.googleSignIn.onCurrentUserChanged
                        .listen((GoogleSignInAccount account) {
                      setState(() {
                        _currentUser = account;
                        if (_currentUser == null) {
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
                },
              ),
            ),
            FutureBuilder(
                future: listUser,
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return (Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data[index].username,
                                          style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
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
                            })));
                  } else {
                    return Container();
                  }
                })
          ],
        )));
  }
}
