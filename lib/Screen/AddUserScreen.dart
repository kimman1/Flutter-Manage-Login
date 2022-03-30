import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget
{
  AddUserScreenState createState() => AddUserScreenState();
}
class AddUserScreenState extends State<AddUserScreen>
{
  Widget build (BuildContext context)
  {
    return(Scaffold(
      appBar: AppBar
      (
        title: Text('Add User'),

      ),
      body: SafeArea
      (
        child: Container(), 
      )
    ));
  }
}