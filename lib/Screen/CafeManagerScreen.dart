// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:manage/Interactive_data/Interactive_Category.dart';
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Screen/ItemScreen.dart';
import 'package:manage/Ultils/Navigate.dart';


class CafeManagerScreen extends StatefulWidget
{
  
  CafeManagerScreenState createState() => CafeManagerScreenState();
  
}
class CafeManagerScreenState extends State<CafeManagerScreen>
{
  Icon iconForListTitle;
  Future<List<Category>> listCategory;
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Cafe Manager State'),
      actions: [searchBar.getSearchAction(context)]
    );
  }
  void onSubmittedSearchBar(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
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
            Text('data'),
            Expanded(
              child: FutureBuilder
              (
                future: listCategory ,
                builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot)
                {
                  if(snapshot.connectionState == ConnectionState.waiting ||snapshot.data.isEmpty )
                  {
                                    return Center
                                    (
                                      child: CircularProgressIndicator(),
                                    );
                      
                     
                  }
                   if (snapshot.connectionState == ConnectionState.done)
                  {
                      
                           if(snapshot.hasData)
                              {
                               
                                  return
                                  (
                                     ListView.builder
                                    (
                                      itemCount: snapshot.data.length,
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
                                                    navi.PushnavigateToAnotherPage(context, ItemScreen(CategoryID: snapshot.data[index].CategoryID,));
                                               
                                                    });
                                                      },
                                              )
                                              
                                            ],
                                          )
                                        );
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
      )
    ));
  }
  
}