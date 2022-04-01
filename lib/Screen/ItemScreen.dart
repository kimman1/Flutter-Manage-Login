// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manage/Interactive_data/Interactive_Item.dart';
import 'package:manage/Model/ItemModel.dart';
import 'package:manage/Ultils/Navigate.dart';

class ItemScreen extends StatefulWidget
{
  String CategoryID;
  ItemScreenState createState() => ItemScreenState();  
  ItemScreen({Key key,
  @required this.CategoryID,
  }) : super(key: key);
}
class ItemScreenState extends State<ItemScreen>
{
  Navigate navi = Navigate();
  InteractiveItem inter = InteractiveItem();
  Future<List<Item>> listItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      listItem = inter.getItemByCategoryID(int.tryParse(widget.CategoryID));
    });
    
  }
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text('Item Screen'),),
      body: SafeArea
      (
        child: Column
        (
          children: 
          [
            FutureBuilder
            (
              future: listItem ,
              builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot)
              {
                   if(snapshot.hasData)
                    {
                      return(
                          Expanded
                          (
                            child: ListView.builder
                            (
                              itemCount: snapshot.data.length ,
                              itemBuilder: (context,index)
                              {
                                return
                                (
                                    Column
                                    (
                                      children: 
                                      [
                                        GestureDetector
                                        (
                                          child:  
                                          Card
                                          (
                                            child: ListTile
                                            (
                                              title: Text
                                              (snapshot.data[index].ItemName),
                                              leading: Icon(Icons.add_comment),
                                              subtitle: Row
                                              (
                                                children: 
                                                [
                                                  Text("Price: " + snapshot.data[index].UnitPrice),
                                                  Icon(Icons.currency_yuan_sharp),
                                                  
                                                ],
                                              )
                                            ),
                                            
                                          ),
                                          onLongPress: ()
                                          {
                                            setState(() 
                                            {
                                              _showCupertinoDialog();
                                            },
                                        );})
                                       
                                      
                                      ],
                                    )
                                );
                              }
                            )
                          ));
                }
                return Container(child: Text('error'));
              }
            )
            
          ],
        )
      ),
    );
  }
   _dismissDialog() {
    Navigator.pop(context);
  }
  void _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Edit Item'),
            content: Card
            (
              child: Column
              (
                children: 
                [
                  TextFormField
                  (
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Item Name',
                    ),
                  ),
                  TextFormField
                  (
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Category',
                    ),
                  ),
                  TextFormField
                  (
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Price',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}