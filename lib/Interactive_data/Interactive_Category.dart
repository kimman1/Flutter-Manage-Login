// @dart=2.9
import 'dart:convert';
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

  Future<String> getUserLogin(User user) async {
    CircularProgressIndicator();
    String dataResponse = "";
    var bodyvalue = user.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response =
        await CategoryAPI.getuserByUserObject(user, bodydata);
    if (response.statusCode == 200) {
      dataResponse = "success";
    } else {
      dataResponse = "failed";
    }
    //print(dataResponse);
    return dataResponse;
  }

  Future<String> createUser(User user) async {
    String dataResponse = "";
    var bodyvalue = user.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response = await CategoryAPI.createUser(user, bodydata);
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

class CategoryAPI {
  static String UrlAPI = 'https://localhost:44375/api/';
  static Future getCategory() {
    return http.get(Uri.parse(UrlAPI + 'Category/GetCategory'));
  }

  static Future getUserById(int id) {
    return http.get(Uri.parse(UrlAPI + 'User/GetUser/' + id.toString()));
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
