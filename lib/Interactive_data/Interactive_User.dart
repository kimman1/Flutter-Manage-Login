// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Model/UserModel.dart';

class Interactive_User {
  JsonReturnModel jsonResult = JsonReturnModel();
  //List<User> listUser;
  Future<List<User>> getAllUser() async {
    final http.Response response = await UserAPI.getUser();
    Iterable l = json.decode(response.body);
    List<User> listUser =
        List<User>.from(l.map((model) => User.fromJSON(model)));
    return listUser;
  }

  Future<String> getUserLogin(User user) async {
    String dataResponse = "";
    var bodyvalue = user.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response =
        await UserAPI.getuserByUserObject(user, bodydata);
    if (response.statusCode == 200) {
      dataResponse = "success";
    } else {
      dataResponse = "failed";
    }
    //print(dataResponse);
    return dataResponse;
  }

  Future<JsonReturnModel> createUser(User user) async {
    var bodyvalue = user.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response = await UserAPI.createUser(user, bodydata);
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    jsonResult = JsonReturnModel.fromJSON(jsonMap);
    return jsonResult;
  }
}

class UserAPI {
  static String UrlAPI = 'http://kimman.somee.com/api/';
  static Future getUser() {
    return http.get(Uri.parse(UrlAPI + 'User/GetUser'));
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
        },
        body: bodydata);
  }
}
