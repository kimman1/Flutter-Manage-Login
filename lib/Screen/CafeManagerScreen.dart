// @dart=2.9
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


class CafeManagerScreen extends StatefulWidget
{
  
  CafeManagerScreenState createState() => CafeManagerScreenState();
  
}
class CafeManagerScreenState extends State<CafeManagerScreen>
{
  String selectedCat = "1";
  Icon iconForListTitle;
  Future<List<Category>> listCategory;
  List<Category> listRefreshSearchBar;
  Future<JsonReturnModel> _addCategoryRetun;
  SearchBar searchBar;
  String searchString = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Cafe Manager State'),
      actions: [searchBar.getSearchAction(context)]
    );
  }
  void onSubmittedSearchBar(String value) {
    setState(() {
      searchString = value;
    });
  }
  
   CafeManagerScreenState() {
    searchBar = new SearchBar(
      inBar: false,
      setState: setState,
      onSubmitted: onSubmittedSearchBar,
      buildDefaultAppBar: buildAppBar
    );
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
  Widget build (BuildContext context)
  {
    return(Scaffold(
      appBar: searchBar.build(context),
      key:  _scaffoldKey,
      body: SafeArea
      (
        child: Column
        (
          children:
          [
            const Text('data'),
            Expanded(
              child: FutureBuilder
              (
                future: listCategory ,
                builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot)
                {
                  if(snapshot.connectionState == ConnectionState.waiting ||snapshot.data.isEmpty )
                  {
                                    return const Center
                                    (
                                      child: CircularProgressIndicator(),
                                    );
                      
                     
                  }
                   if (snapshot.connectionState == ConnectionState.done)
                  {
                      
                           if(snapshot.hasData)
                              {
                                listRefreshSearchBar = snapshot.data;
                                  return
                                  (
                                     ListView.builder
                                    (
                                      itemCount:  
                                      snapshot.data.length,
                                      itemBuilder: (context,index)
                                      {
                                        String dataToGetIcon = snapshot.data[index].CategoryName;
                                        if(dataToGetIcon == "Cafe")
                                        {
                                          
                                            iconForListTitle = const Icon(Icons.local_cafe);
                                        
                                        }
                                        else if(dataToGetIcon == "Food")
                                        {
                                          
                                            iconForListTitle = const Icon(Icons.food_bank);
                                        
                                        }
                                        return(
                                          snapshot.data[index].CategoryName.toLowerCase().contains(searchString) ?
                                          Column(
                                            children: 
                                            [
                                              GestureDetector
                                              (
                                                child:Card(
                                                      child: ListTile
                                                      (
                                                        title: Text(snapshot.data[index].CategoryName),
                                                        leading: 
                                                        iconForListTitle,
                                                      ),
                                                    
                                                  ) ,
                                                  onTap: ()
                                                  {
                                                    setState(() {
                                                       Navigate navi = Navigate();
                                                    navi.PushnavigateToAnotherPage(context, ItemScreen(CategoryID: snapshot.data[index].CategoryID, categoryName: snapshot.data[index].CategoryName,));
                                               
                                                    });
                                                  },
                                                  
                                              )
                                              
                                            ],
                                          )
                                    : Container());
                                      }
                                    )
                                  );
                             
                                }
                                else
                                {
                                  
                                      return Center( child:  CircularProgressIndicator(
                              backgroundColor: Colors.blue));                                 

                                }
                
                  }
                return Center(child: CircularProgressIndicator(),);    
                }
                ),
            ),
                   
          ],
        )
      ),
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
                onTap: () 
                {
                  _showCupertinoDialogAddCategory();
                  
                }, 
                label: 'Add new Category',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                labelBackgroundColor: Colors.black,
              )
            ],
          )
        ,
    ));
    
  }

    _dismissDialog() {
    Navigator.pop(context);
  }

  void _showCupertinoDialogAddCategory () async {
     bool showProgress = false;
     
  TextEditingController CategoryNameController = TextEditingController();
  TextEditingController CategoryDescriptionController = TextEditingController();
  
    showDialog  (
        context: context,
        builder: (context) {
          return  CupertinoAlertDialog(
            title: const Text('Add Category'),
            content: Card
            (
              child: Column
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
                    controller:  CategoryDescriptionController,
                    decoration: const InputDecoration
                    (
                      border: UnderlineInputBorder(),
                      labelText: 'Category Discription',
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
                          Category catSendAPI = Category();
                          catSendAPI.CategoryName = CategoryNameController.text;
                          catSendAPI.Description = CategoryDescriptionController.text;
                          DialogCreate create = DialogCreate();
                          create.showMaterialDialog(context, "Notice", "Please waiting...");
                          InteractiveCategory inter = InteractiveCategory();
                           JsonReturnModel response = await  inter.createCategory(catSendAPI);  
                           if(response.statusCode == "200")
                           {
                             create.dismissDialog(context);
                             Navigate navi = Navigate();
                             navi.PopnavigateToAnotherPage(context);
                             navi.PopnavigateToAnotherPage(context);
                             navi.PushnavigateToAnotherPage(context, CafeManagerScreen());
                           }
                           else
                           {
                             create.dismissDialog(context);
                             create.showMaterialDialog(context, "Error", response.message);
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
 
  }} 
