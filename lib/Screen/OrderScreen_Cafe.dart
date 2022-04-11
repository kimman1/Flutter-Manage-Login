//@dart=2.9

// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Interactive_data/Interactive_Item.dart';
import 'package:manage/Interactive_data/Interactive_Order.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/ItemModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Model/OrderModel.dart';
import 'package:manage/Screen/CafeManagerScreen.dart';
import 'package:manage/Ultils/DialogMaterial.dart';
import 'package:manage/Ultils/Navigate.dart';

class OrderScreen extends StatefulWidget {
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Navigate navi = Navigate();
  Future<List<Category>> listCategory;
  InteractiveCategory interCat = InteractiveCategory();
  InteractiveItem interItem = InteractiveItem();
  InteractiveOrder interOrder = new InteractiveOrder();
  InteractiveOrderDetail interOrderDetail = new InteractiveOrderDetail();
  Future<List<Item>> listItem;
  List<OrderDetail> listOrderDetail = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      listCategory = interCat.getAllCategory();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Order Screen')),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listOrderDetail.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (Card(
                        child: ListTile(
                          title: Text(listOrderDetail[index].ItemName),
                          subtitle: Text(
                              "Quantity : " + listOrderDetail[index].Quantity),
                        ),
                      ));
                    }))
          ],
        )),
        drawer: SafeArea(
          child: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Category')),
            Container(
              height: double.maxFinite,
              child: FutureBuilder(
                future: listCategory,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Category>> snapshot) {
                  if (snapshot.hasData) {
                    return (Container(
                      height: double.maxFinite,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (contextItem, index) {
                            return Card(
                                child: new ListTile(
                              title: Text(snapshot.data[index].CategoryName),
                              leading: const Icon(Icons.local_cafe_outlined),
                              onTap: () {
                                navi.PopnavigateToAnotherPage(context);
                                showMaterialDialogOrderItem(
                                    contextItem,
                                    'Title',
                                    'Content',
                                    snapshot.data[index].CategoryID);
                              },
                            ));
                          }),
                    ));
                  }
                  return Container();
                },
              ),
            )
          ])),
        ));
  }

  void dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void showMaterialDialogOrderItem(
      BuildContext context, String Title, String Content, String id) {
    InteractiveItem interItem = InteractiveItem();

    setState(() {
      listItem = interItem.getItemByCategoryID(int.tryParse(id));
    });

    showDialog(
        context: context,
        builder: (BuildContext contextDialog) {
          return (Center(
            child: AlertDialog(
                alignment: Alignment.center,
                title: Text(Title),
                content: FutureBuilder(
                  future: listItem,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Item>> snapshot) {
                    if (snapshot.hasData) {
                      return (Container(
                        height: MediaQuery.of(context).size.height *
                            0.3, // Change as per your requirement
                        width: MediaQuery.of(context).size.width *
                            0.1, // Change as per your requirement
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder:
                              (BuildContext contextListView, int index) {
                            return Card(
                              child: ListTile(
                                title: Text(snapshot.data[index].ItemName),
                                leading: Icon(Icons.local_cafe_outlined),
                                onTap: () {
                                  setState(() {
                                    OrderDetail od = OrderDetail();
                                    od.ItemID = snapshot.data[index].ItemID;
                                    od.ItemName = snapshot.data[index].ItemName;
                                    od.Quantity = "1";
                                    if (listOrderDetail
                                        .where((element) =>
                                            element.ItemID == od.ItemID)
                                        .isEmpty) {
                                      listOrderDetail.add(od);
                                      interOrderDetail.createOrderDetail(od);
                                    } else {
                                      var odd = listOrderDetail.where(
                                          (element) =>
                                              element.ItemID == od.ItemID);
                                      if (odd.isNotEmpty) {
                                        odd.first.Quantity =
                                            (int.tryParse(odd.first.Quantity) +
                                                    1)
                                                .toString();
                                        print(listOrderDetail
                                            .where((element) =>
                                                element.ItemID == od.ItemID)
                                            .first
                                            .Quantity);
                                      }
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ));
                    }
                    return Container();
                  },
                )),
          ));
        });
  }

  Widget setupAlertDialoadContainer(List<Item> listItem) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listItem.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(listItem[index].ItemName),
          );
        },
      ),
    );
  }
}
