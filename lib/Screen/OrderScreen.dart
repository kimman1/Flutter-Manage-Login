import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget
{
  OrderScreenState createState() => OrderScreenState();
}
class OrderScreenState extends State<OrderScreen>
{
  Widget build (BuildContext context)
  {
    return(Scaffold(
      appBar: AppBar
      (
        title: Text('Order Screen'),

      ),
      body: SafeArea
      (
        child: Container(
          child: Container() ,
        ), 
      )
    ));
  }
}