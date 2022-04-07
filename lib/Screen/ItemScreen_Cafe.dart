// @dart=2.9

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Interactive_data/Interactive_Item.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/ItemModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Screen/CafeManagerScreen.dart';
import 'package:manage/Screen/SelectionScreen.dart';
import 'package:manage/Ultils/DialogMaterial.dart';
import 'package:manage/Ultils/Navigate.dart';

class ItemScreen extends StatefulWidget
{
  String CategoryID;
  String categoryName;
  ItemScreenState createState() => ItemScreenState();  
  ItemScreen({Key key,
  @required this.CategoryID,
  this.categoryName,
  }) : super(key: key);
}
class ItemScreenState extends State<ItemScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
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
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Item Screen ' + widget.categoryName.toString()),),
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
                                if(snapshot.hasData)
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
                                                          const Icon(Icons.currency_pound_outlined),
                                                          
                                                        ],
                                                      )
                                                    ),
                                                    
                                                  ),
                                                  onLongPress: ()
                                                  {
                                                    setState
                                                    (() 
                                                    {
                                                      _showCupertinoDialog(snapshot, index);
                                                    },
                                                    );
                                                  }
                                                )
                                              ],
                                            )
                                        );
                                  }
                                else
                                {
                                 // DialogCreate createDialog = DialogCreate();
                                  return
                                  (
                                    Container
                                    (
                                      child: Center
                                      (
                                        child: Text("error"),
                                      ), 
                                    )
                                  );
                                }
                              }
                            )
                          ));
                }
                return (Center(child: AlertDialog(title: Text('Notice'),content: Text('Please wait when loading data\nif more than 10s please contact administrator.'),)));
              }
            )
            
          ],
        )
      ),
      floatingActionButton: SpeedDial(
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
            onTap: () {
              _showMaterialDialogAddItem();
            },
            label: 'Add new Item',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            child: Icon(Icons.remove, color: Colors.white),
            backgroundColor: Colors.red,
            onTap: () {
              
            },
            label: 'Delete Selected Item',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          )
        ],
      ),
      
    );
  }
   _dismissDialog() {
    Navigator.pop(context);
  }
  void _showMaterialDialogAddItem() {
    TextEditingController ItemNameController = TextEditingController();
    TextEditingController UnitPriceController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Item'),
            content: Text('Please input data'),
            actions: <Widget>[
                Column
                (
                  children: 
                  [
                    TextFormField
                    (
                      controller: ItemNameController,
                        decoration: const InputDecoration
                            (
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Item Name',
                            ),
                    ),
                    TextFormField
                    (
                      controller: UnitPriceController,
                        decoration: const InputDecoration
                            (
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Unit Price',
                            ),
                    ),
                    Row
                    (
                      children: 
                      [
                        ElevatedButton
                        (
                          onPressed: () async
                          {
                            Item itemSendAPI = Item();
                            InteractiveItem inter = InteractiveItem();
                            DialogCreate create = DialogCreate();
                            if(ItemNameController.text != null)
                            {
                              itemSendAPI.ItemName = ItemNameController.text;
                            }
                            if(UnitPriceController.text != null)
                            {
                              itemSendAPI.UnitPrice = UnitPriceController.text;
                            }
                            itemSendAPI.CategoryID = widget.CategoryID;
                            JsonReturnModel jsonResult = await inter.createItem(itemSendAPI);
                            if(jsonResult.statusCode == "200")
                            {
                              create.showMaterialDialogWithWidget(context, "Notice", jsonResult.message, ItemScreen(CategoryID: widget.CategoryID));
                            }
                          }, 
                          child: Text('Submit')
                        ),
                        SizedBox
                        (
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                        ElevatedButton
                        (
                          onPressed: ()
                          {
                            _dismissDialog();
                          }, 
                          child: Text('Cancel')
                        )
                      ],
                    )
                  ],
                )
            ],
          );
        });
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
  void _showCupertinoDialog (AsyncSnapshot<List<Item>> snapshot, var index) async {
     bool showProgress = false;
     
  TextEditingController ItemNameController = TextEditingController(text: snapshot.data[index].ItemName);
  TextEditingController CategoryIDController = TextEditingController(text: snapshot.data[index].CategoryID);
  TextEditingController UnitPriceController = TextEditingController(text: snapshot.data[index].UnitPrice);
    showDialog  (
        context: context,
        builder: (context) {
          return  CupertinoAlertDialog(
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
                      
                      return
                      (
                        Row
                        (
                          children: 
                          [
                            Text('Cagetory:  '),
                             Expanded
                             (
                               child: DropdownButtonFormField<String>
                      (
                         value: selectedCat,
                         items: snapshot.data.map((Category map) 
                        {
                          return
                           DropdownMenuItem<String>
                          (
                            value: map.CategoryID,
                            child: Text(map.CategoryName)
                          );
                        }).toList(),
                        onSaved: (String newValue)
                        {
                          setState(() {
                            selectedCat = newValue; 
                            selectedCat = selectedCat;
                          });
                       
                        },
                        onChanged: (String newValue)
                        {
                          setState(() {
                            selectedCat = newValue; 
                               
                          });
                       
                        },
                      )      
                              )  
                          ],
                        )
                      ); 
                      
                    }
                  ),
                  TextFormField
                  (
                    controller:  UnitPriceController,
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
                          String oldIDCategory = snapshot.data[index].ItemID;
                          Item itemSendAPI = Item();
                          itemSendAPI.ItemID = snapshot.data[index].ItemID;
                          itemSendAPI.CategoryID = selectedCat;
                          itemSendAPI.ItemName = ItemNameController.text;
                          itemSendAPI.UnitPrice = UnitPriceController.text;
                          setState(() {
                            print((selectedCat));
                            _showMaterialDialog("Notice", "Please waiting....");
                          });
                          //List<Item> listItemOldCategory = await inter.getItemByCategoryID(int.tryParse(oldIDCategory));
                          JsonReturnModel resp = await inter.editItem(itemSendAPI);
                           if(resp.statusCode == "200")
                          {
                              setState(()  {
                            showProgress = false;
                             _dismissDialog(); // dismiss dialog material
                             _dismissDialog(); // dismiss cupertino dialog
                             navi.PopnavigateToAnotherPage(context); // pop the screen
                             navi.PopnavigateToAnotherPage(context);
                             navi.PushnavigateToAnotherPage(context, CafeManagerScreen());
                             
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
                        width: MediaQuery.of(context).size.width*0.05,
                      ),
                      ElevatedButton
                      (
                        onPressed:()
                        {
                          _dismissDialog();
                        },
                         child: const Text("Cancel"),
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