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

  Future<JsonReturnModel> createCategory(Category cat) async {
    var bodyvalue = cat.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response =
        await CategoryAPI.createCategory(cat, bodydata);
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
    return jsonResult;
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

  static Future getuserByUserObject(User user, String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'User/GetUserByUser'),
        headers: {
          "Content-Type": "application/json",
        },
        body: bodydata);
  }

  static Future createCategory(Category cat, String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'Category/CreateCategory'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }
}
