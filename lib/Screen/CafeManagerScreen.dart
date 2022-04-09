// @dart=2.9
// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Screen/ItemScreen_Cafe.dart';
import 'package:manage/Ultils/DialogMaterial.dart';
import 'package:manage/Ultils/Navigate.dart';

class CafeManagerScreen extends StatefulWidget {
  CafeManagerScreenState createState() => CafeManagerScreenState();
}

class CafeManagerScreenState extends State<CafeManagerScreen> {
  String selectedIndex;
  List<String> listTest = [];
  var isSelected = false;
  var mycolor = Colors.white;
  String selectedCat = "1";
  Icon iconForListTitle;
  Future<List<Category>> listCategory;
  List<Category> listRefreshSearchBar;
  SearchBar searchBar;
  String searchString = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Cafe Manager State'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmittedSearchBar(String value) {
    setState(() {
      searchString = value;
    });
  }

  CafeManagerScreenState() {
    // ignore: unnecessary_new
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmittedSearchBar,
        buildDefaultAppBar: buildAppBar);
  }
  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.grey[300];
        isSelected = true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      InteractiveCategory inter = InteractiveCategory();
      listCategory = inter.getAllCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: SafeArea(
          child: Column(
        children: [
          const Text('data'),
          Expanded(
            child: FutureBuilder(
                future: listCategory,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Category>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      listRefreshSearchBar = snapshot.data;
                      return (ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            String dataToGetIcon =
                                snapshot.data[index].CategoryName;
                            if (dataToGetIcon == "Cafe") {
                              iconForListTitle = const Icon(Icons.local_cafe);
                            } else if (dataToGetIcon == "Food") {
                              iconForListTitle = const Icon(Icons.food_bank);
                            }
                            return (snapshot.data[index].CategoryName
                                    .toLowerCase()
                                    .contains(searchString)
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        child: Card(
                                          color: listTest.contains(snapshot
                                                  .data[index].CategoryID)
                                              ? Colors.blue
                                              : null,
                                          child: ListTile(
                                            selected: isSelected,
                                            title: Text(snapshot
                                                .data[index].CategoryName),
                                            leading: iconForListTitle,
                                          ),
                                        ),
                                        onHorizontalDragUpdate: (details) 
                                        {  

                                            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                                            int sensitivity = 7;
                                            if (details.delta.dx > sensitivity) {
                                                setState(() {
                                                 listTest.remove(snapshot
                                                .data[index].CategoryID);
                                                  print('right swipe');
                                                });
                                                // Right Swipe
                                            } else if(details.delta.dx < -sensitivity){
                                                //Left Swipe
                                                setState(() {
                                                  if (!listTest.contains(snapshot.data[index].CategoryID)) 
                                                {
                                                  listTest.add(snapshot.data[index].CategoryID);
                                                }
                                                  print('left swipe');
                                                });
                                            }
                                        },
                                       
                                        onTap: () {
                                          setState(() {
                                            if (listTest.isNotEmpty) {
                                              for (String i in listTest) {
                                                print(i);
                                              }
                                            }
                                            Navigate navi = Navigate();
                                            navi.PushnavigateToAnotherPage(
                                                context,
                                                ItemScreen(
                                                  CategoryID: snapshot
                                                      .data[index].CategoryID,
                                                  categoryName: snapshot
                                                      .data[index].CategoryName,
                                                ));
                                          });
                                        },
                                        onLongPress: ()
                                        {
                                          
                                          _showMaterialDialogEditCategory('Editing Category','Please input all the field',snapshot.data[index]);
                                        },
                                      )
                                    ],
                                  )
                                : Container());
                          }));
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.blue));
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      )),
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
              _showCupertinoDialogAddCategory();
            },
            label: 'Add new Category',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            child: Icon(Icons.remove, color: Colors.white),
            backgroundColor: Colors.red,
            onTap: () {
              DialogCreate create = DialogCreate();
              create.showMaterialDialogWithDeleteTemplate(context, listTest, "Category");
            },
            label: 'Delete Selected Category',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          )
        ],
      ),
      
    ));
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
  void _showMaterialDialogEditCategory(String Title, String Content, Category cat) {
    TextEditingController CategoryNameController = TextEditingController(text: cat.CategoryName);
    TextEditingController DescriptionController = TextEditingController(text: cat.Description);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Title),
            content: Text(Content),
              actions: 
              [
                  Column
                  (
                    children: 
                    [
                      TextFormField
                     (
                       controller: CategoryNameController,
                              decoration: const InputDecoration
                            (
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Category Name',
                            ),
                      ),
                      TextFormField
                     (
                       controller: DescriptionController,
                              decoration: const InputDecoration
                            (
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Category Description',
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
                            onPressed: ()
                            async {
                              Navigate navi = Navigate();
                              InteractiveCategory inter = InteractiveCategory();
                              DialogCreate create = DialogCreate();
                              create.showMaterialDialog(context, "Notice", "Please waiting...");
                              Category catSendAPI = Category();
                              catSendAPI.CategoryID = cat.CategoryID;
                              if(CategoryNameController.text != null)
                              {
                              catSendAPI.CategoryName = CategoryNameController.text;
                              }
                              else
                              {
                                catSendAPI.CategoryName = cat.CategoryName;
                              }
                              if(DescriptionController.text != null)
                              {
                                catSendAPI.Description = DescriptionController.text; 
                              }
                              else
                              {
                                catSendAPI.Description = cat.Description;
                              }
                              
                              JsonReturnModel jsonReturn = await inter.editCategory(catSendAPI);
                              if(jsonReturn.statusCode == "200")
                              {
                                create.dismissDialog(context);
                                create.showMaterialDialog(context, "Notice", jsonReturn.message);
                                navi.PopnavigateToAnotherPage(context);
                                navi.PopnavigateToAnotherPage(context);
                                navi.PopnavigateToAnotherPage(context);
                                navi.PushnavigateToAnotherPage(context, CafeManagerScreen());
                              }
                              else
                              {
                                create.dismissDialog(context);
                                create.showMaterialDialog(context, "Notice", jsonReturn.message);
                              }
                            }, 
                            child: const Text('Submit')
                          ),
                          SizedBox
                          (
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          ElevatedButton
                          (
                            onPressed: ()
                            {
                              _dismissDialog();
                            }, 
                            child: const Text('Cancel')
                          )
                        ],
                      )
                      ],
                  ) ,
                ],
          );
        });
  }
  void _showCupertinoDialogAddCategory() async {
    bool showProgress = false;

    TextEditingController CategoryNameController = TextEditingController();
    TextEditingController CategoryDescriptionController =
        TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Add Category'),
            content: Card(
              child: Column(
                children: [
                  TextFormField(
                    controller: CategoryNameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Category Name',
                    ),
                  ),
                  TextFormField(
                    controller: CategoryDescriptionController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Category Discription',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            Category catSendAPI = Category();
                            catSendAPI.CategoryName =
                                CategoryNameController.text;
                            catSendAPI.Description =
                                CategoryDescriptionController.text;
                            DialogCreate create = DialogCreate();
                            create.showMaterialDialog(
                                context, "Notice", "Please waiting...");
                            InteractiveCategory inter = InteractiveCategory();
                            JsonReturnModel response =
                                await inter.createCategory(catSendAPI);
                            if (response.statusCode == "200") {
                              create.dismissDialog(context);
                              Navigate navi = Navigate();
                              navi.PopnavigateToAnotherPage(context);
                              navi.PopnavigateToAnotherPage(context);
                              navi.PushnavigateToAnotherPage(
                                  context, CafeManagerScreen());
                            } else {
                              create.dismissDialog(context);
                              create.showMaterialDialog(
                                  context, "Error", response.message);
                            }
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ElevatedButton(
                        onPressed: () {
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
