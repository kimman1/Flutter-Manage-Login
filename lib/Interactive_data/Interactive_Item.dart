// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/ItemModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Model/UserModel.dart';

class InteractiveItem {
  //List<User> listUser;
  Future<Item> getItemByItemID(String id) async {
    final http.Response response = await ItemAPI.getItemByID(id);
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
        Item jsonResult = Item.fromJSON(jsonMap);
    return jsonResult;
  }
  Future<List<Item>> getAllItem() async {
    final http.Response response = await ItemAPI.getItem();
    Iterable l = json.decode(response.body);
    List<Item> listItem =
        List<Item>.from(l.map((model) => Item.fromJSON(model)));
    return listItem;
  }

  Future<List<Item>> getItemByCategoryID(int CatID) async {
    final http.Response response = await ItemAPI.getItemByCategoryID(CatID);
    Iterable l = json.decode(response.body);
    List<Item> listItem =
        List<Item>.from(l.map((model) => Item.fromJSON(model)));
    return listItem;
  }

  Future<JsonReturnModel> editItem(Item item) async {
    JsonReturnModel jsonResult = JsonReturnModel();

    var bodyvalue = item.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response = await ItemAPI.EditItem(bodydata);
    if (response.statusCode == 200) {
      jsonResult.statusCode = response.statusCode.toString();
      jsonResult.message = "OK";
      return jsonResult;
    } else {
      Iterable l = json.decode(response.body);
      List<JsonReturnModel> listResponse = List<JsonReturnModel>.from(
          l.map((model) => JsonReturnModel.fromJSON(model)));
      for (JsonReturnModel i in listResponse) {
        jsonResult = i;
      }
      return jsonResult;
    }
  }
  Future<JsonReturnModel> createItem(Item item) async {
    try
    {
         var bodyvalue = item.toJSON();
        var bodydata = json.encode(bodyvalue);
        final http.Response response =
            await ItemAPI.createItem(bodydata);
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
        return jsonResult;
    }
    catch (e)
    {
      JsonReturnModel jsonResult = JsonReturnModel();
      
          if(e is SocketException)
          {
            
            jsonResult.statusCode = "500";
            jsonResult.message = "Socket exception error";
           
            //print('socket exception');
          }
          else if(e is TimeoutException)
          {
             
            jsonResult.statusCode = "408";
            jsonResult.message = "Time Out";
            
            //print("time out");
          }
          else if(e is HttpException)
          {
             
            jsonResult.statusCode = "ERR_CODE";
            jsonResult.message = "Http Exception";
           
          }
          else
          {
            
            jsonResult.statusCode = "Unknow";
            jsonResult.message = "Unknow";
            
          
            //print('unknow' + e.toString());
          }
          return jsonResult;
        }
    }
    Future<List<JsonReturnModel>> deleteItem(List<String> ListItemID) async {
    List<JsonReturnModel> listJsonReturn = [];
    try
    {
      for(String i in ListItemID)
      {
        final http.Response response =
            await ItemAPI.deleteItem(i);
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
        listJsonReturn.add(jsonResult);
      }
    }
    catch (e)
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
        return listJsonReturn;
    }
  }


class ItemAPI {
  static String UrlAPI = 'http://kimman.somee.com/api/';
  static Future getItem() {
    return http.get(Uri.parse(UrlAPI + 'Item/GetItem'));
  }

  static Future getItemByID(String id) {
    return http.get(Uri.parse(UrlAPI + 'Item/GetItemByID/$id'));
  }

  static Future getItemByCategoryID(int CategoryID) {
    return http.get(Uri.parse(UrlAPI +
        'Item/GetItemByCategoryID?CategoryID=' +
        CategoryID.toString()));
  }

  static Future EditItem(String bodydata) {
    return http.put(Uri.parse(UrlAPI + 'Item/PutItem'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }

  static Future createItem(String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'Item/CreateItem'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }
  static Future deleteItem( String ItemID) {
    return http.delete(Uri.parse(UrlAPI + 'Item/DeleteItem/$ItemID'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
       );
  }
}
