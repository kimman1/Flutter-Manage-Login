// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Model/UserModel.dart';

class InteractiveCategory {
  //List<User> listUser;
  Future<List<Category>> getAllCategory() async {
    final http.Response response = await CategoryAPI.getCategory();
    Iterable l = json.decode(response.body);
    List<Category> listCategory =
        List<Category>.from(l.map((model) => Category.fromJSON(model)));
    return listCategory;
  }

  Future<JsonReturnModel> createCategory(Category cat) async {
    var bodyvalue = cat.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response =
        await CategoryAPI.createCategory(cat, bodydata);
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
    return jsonResult;
  }

  Future<List<JsonReturnModel>> deleteCategory(List<String> listID) async {
   List<JsonReturnModel> listJsonReturn = [];
    try{
    
    for(String i in listID)
    {
      
            http.Response response =
            await CategoryAPI.deleteCategory(i).timeout(const Duration(seconds: 10));
           Map<String, dynamic> jsonMap = jsonDecode(response.body);
            JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
            listJsonReturn.add(jsonResult);
            //return listJsonReturn;
    } 
    return listJsonReturn;
    }
         catch(e)
        {
          if(e is SocketException)
          {
            JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "500";
            jsonResult.message = "Socket exception error";
            listJsonReturn.add(jsonResult);
            //print('socket exception');
          }
          else if(e is TimeoutException)
          {
              JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "408";
            jsonResult.message = "Time Out";
            listJsonReturn.add(jsonResult);
            //print("time out");
          }
          else if(e is HttpException)
          {
             JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "ERR_CODE";
            jsonResult.message = "Http Exception";
            listJsonReturn.add(jsonResult);
          }
          else
          {
            JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "Unknow";
            jsonResult.message = "Unknow";
            listJsonReturn.add(jsonResult);
          
            //print('unknow' + e.toString());
          }
        }
    
  }
  Future<JsonReturnModel> editCategory (Category cat) async {
      
      try
      {
        JsonReturnModel jsonResult = JsonReturnModel();
           var bodyvalue = cat.toJSON();
        var bodydata = json.encode(bodyvalue);
      http.Response response =
            await CategoryAPI.editCategory(bodydata).timeout(Duration(seconds: 4));
           Map<String, dynamic> jsonMap = jsonDecode(response.body);
             jsonResult = JsonReturnModel.fromJSON(jsonMap);
            return jsonResult;
      }
      catch (e)
      {
         if(e is SocketException)
          {
            JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "500";
            jsonResult.message = "Socket exception error";
           
            return jsonResult;
          }
          else if(e is TimeoutException)
          {
              JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "408";
            jsonResult.message = "Time Out";
            
            return jsonResult;
          }
          else if(e is HttpException)
          {
             JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "ERR_CODE";
            jsonResult.message = "Http Exception";
            
            return jsonResult;
          }
          else
          {
            JsonReturnModel jsonResult = JsonReturnModel();
            jsonResult.statusCode = "Unknow";
            jsonResult.message = "Unknow";
            
            return jsonResult;
          
            
          }       
      }
  }
}

class CategoryAPI {
  static String UrlAPI = 'http://kimman.somee.com/api/';
  static Future getCategory() {
    return http.get(Uri.parse(UrlAPI + 'Category/GetCategory'));
  }

  static Future getUserById(int id) {
    return http.get(Uri.parse(UrlAPI + 'User/GetUser/' + id.toString()));
  }

  static Future createCategory(Category cat, String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'Category/CreateCategory'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }
  static Future deleteCategory(String catID) {
    return http.delete(Uri.parse(UrlAPI + 'Category/DeleteCategory/$catID'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }
        );
  }
  static Future editCategory( String bodydata) {
    return http.put(Uri.parse(UrlAPI + 'Category/putCategory/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata
        );
  }
}
