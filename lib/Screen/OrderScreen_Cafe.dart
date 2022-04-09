//@dart=2.9

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Ultils/DialogMaterial.dart';

class OrderScreen extends StatefulWidget
{
  OrderScreenState createState() => OrderScreenState();
}
class OrderScreenState extends State<OrderScreen>
{
  Future<List<Category>> listCategory;
  @override
  void initState() {
    InteractiveCategory interCat = InteractiveCategory();
    // TODO: implement initState
    super.initState();
    setState(()  {
      listCategory =  interCat.getAllCategory();
    });
    
  }
   Widget build(BuildContext context)
   {  
      return Scaffold
      (
          appBar: AppBar(title: Text('Order Screen')),
          body: Text('data'),
          drawer: Drawer
          (
            child: Expanded
            (
              child:  ListView
            (
              padding: EdgeInsets.zero,
              children: 
              [
                const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
                 child: Text('Category') 
                 
                 ),
                 Container
                 (
                    height: double.maxFinite,
                    child: 
                    Expanded
                    (
                      child: FutureBuilder
                      (
                        future: listCategory ,
                        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot)
                        {
                              if(snapshot.hasData)
                              {
                                  return
                                  (
                                    Container
                                    (
                                      height: double.maxFinite,
                                      child: ListView.builder
                                      (
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context,index)
                                        {
                                          return
                                          Card
                                          (
                                            child: new ListTile(
                                            title: Text(snapshot.data[index].CategoryName),
                                            leading: Icon(Icons.local_cafe_outlined),
                                          )
                                           
                                          );
                                        }
                                      ),
                                    )
                                  );
                              }
                              return Container();
                        },
                      ),
                    )
                  ) 
                 
              ]) 
            
          ),
      ));
   }
}