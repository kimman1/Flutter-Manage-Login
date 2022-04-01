// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manage/Model/CategoryModel.dart';
import 'package:manage/Model/ItemModel.dart';
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Model/UserModel.dart';

class InteractiveItem {
  //List<User> listUser;
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
 

  Future<String> createUser(User user) async {
    String dataResponse = "";
    var bodyvalue = user.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response = await ItemAPI.createUser(user, bodydata);
    Iterable l = json.decode(response.body);
    List<JsonReturnModel> listResponse = List<JsonReturnModel>.from(
        l.map((model) => JsonReturnModel.fromJSON(model)));
    for (JsonReturnModel i in listResponse)
    {
      dataResponse += i.message;
    }
    return dataResponse;
  }
}

class ItemAPI {
  static String UrlAPI = 'http://kimman.somee.com/api/';
  static Future getItem() {
    return http.get(Uri.parse(UrlAPI + 'Item/GetItem'));
  }

  static Future getItemByID(int id) {
    return http.get(Uri.parse(UrlAPI + 'Item/GetItemByID/' + id.toString()));
  }
  static Future getItemByCategoryID(int CategoryID) {
    return http.get(Uri.parse(UrlAPI + 'Item/GetItemByCategoryID?CategoryID=' + CategoryID.toString()));
  }
  static Future getuserByUserObject(User user, String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'User/GetUserByUser'),
        headers: {
          "Content-Type": "application/json",
        },
        body: bodydata);
  }

  static Future createUser(User user, String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'User/CreateUser'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*"
        },
        body: bodydata);
  }
}
