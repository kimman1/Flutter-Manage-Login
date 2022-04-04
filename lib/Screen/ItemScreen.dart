// @dart=2.9

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Interactive_data/Interactive_Item.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/ItemModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Navigate navi = Navigate();
  InteractiveItem inter = InteractiveItem();
  InteractiveCategory interCategory = InteractiveCategory();
  Future<List<Item>> listItem;
  Future<List<Category>> listCategory;
  String selectedCat = "1";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      listCategory = interCategory.getAllCategory();
      listItem = inter.getItemByCategoryID(int.tryParse(widget.CategoryID));
    });
    
  }
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      key: _scaffoldKey,
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
                                              _showCupertinoDialog(snapshot, index);
                                            },
                                        );})
                                       
                                      
                                      ],
                                    )
                                );
                              }
                            )
                          ));
                }
                return Center(child: Container(child: CircularProgressIndicator(),));
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
     void _showMaterialDialog(String Title, String Content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Title),
            content: Text(Content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text('Close')),
            ],
          );
        });
  }
  void _showCupertinoDialog(AsyncSnapshot<List<Item>> snapshot, var index) {
     bool showProgress = false;
     
  TextEditingController ItemNameController = TextEditingController(text: snapshot.data[index].ItemName);
  TextEditingController CategoryIDController = TextEditingController(text: snapshot.data[index].CategoryID);
  TextEditingController UnitPriceController = TextEditingController(text: snapshot.data[index].UnitPrice);
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
                    controller: ItemNameController,
                    //initialValue: snapshot.data[index].ItemName ,
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Item Name',
                    ),
                  ),
                  FutureBuilder
                  (
                    future: listCategory,
                    builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot)
                    {
                      
                      return DropdownButtonFormField<String>
                      (
                        value: selectedCat,
                        //items: snapshot.data.map((Category) => 
                       // DropdownMenuItem<String>(child: Text(Category.CategoryName),value: Category.CategoryName,)).toList(), 
                        items: snapshot.data.map((Category map) 
                        {
                          return new DropdownMenuItem<String>
                          (
                            value: map.CategoryID,
                            child: Text(map.CategoryName)
                          );
                        }).toList(),
                        onSaved: (String newValue)
                        {
                          setState(() {
                            selectedCat = newValue; 
                            print(newValue);   
                          });
                       
                        },
                        onChanged: (String newValue)
                        {
                          setState(() {
                            selectedCat = newValue; 
                            print(newValue);   
                          });
                       
                        },
                      );
                    }
                  ),
                  TextFormField
                  (
                    controller:  CategoryIDController,
                    // initialValue: snapshot.data[index].CategoryID ,
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Category',
                    ),
                  ),
                  TextFormField
                  (
                    controller:  UnitPriceController,
                     //initialValue: snapshot.data[index].UnitPrice ,
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Price',
                    ),
                  ),
                  
                  Row
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: 
                    [
                      ElevatedButton
                      (
                        child: const Text('Submit'),
                        onPressed: () async 
                        {
                          Item itemSendAPI = Item();
                          itemSendAPI.ItemID = snapshot.data[index].ItemID;
                          itemSendAPI.CategoryID = CategoryIDController.text;
                          itemSendAPI.ItemName = ItemNameController.text;
                          itemSendAPI.UnitPrice = UnitPriceController.text;
                          setState(() {
                            _showMaterialDialog("Notice", "Please waiting....");
                          });
                          JsonReturnModel resp = await inter.editItem(itemSendAPI);
                          if(resp.statusCode == "200")
                          {
                              setState(() {
                            showProgress = false;
                             _dismissDialog(); // dismiss dialog material
                             _dismissDialog(); // dismiss cupertino dialog
                             navi.PopnavigateToAnotherPage(context); // pop the screen
                             navi.PushnavigateToAnotherPage(context, ItemScreen(CategoryID: snapshot.data[index].CategoryID));
                          });
                          }
                          else
                          {
                            setState(() {
                                _showMaterialDialog("Error", resp.message);
                            });
                          }
                          
                          
                          }
                      ),
                      SizedBox
                      (
                        width: 30,
                      ),
                      ElevatedButton
                      (
                        onPressed:()
                        {
                          _dismissDialog();
                          print("Cancel");
                        },
                         child: Text("Cancel"),
                      ),
                    ],
                  )
                  
                ],
              ),
            ),
          );
        });
   
  }
}