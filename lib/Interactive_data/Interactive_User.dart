// @dart=2.9
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:manage/Model/UserModel.dart';

class Interactive_User {
  //List<User> listUser;
  Future<List<User>> getAllUser() async {
    final http.Response response = await UserAPI.getUser();
    Iterable l = json.decode(response.body);
    List<User> listUser =
        List<User>.from(l.map((model) => User.fromJSON(model)));

    return listUser;
  }
}

class UserAPI {
  static String UrlAPI = 'https://localhost:44375/api/';
  static Future getUser() {
    return http.get(Uri.parse(UrlAPI + 'User'));
  }

  static Future getUserById(int id) {
    return http.get(Uri.parse(UrlAPI + 'User/GetUser/' + id.toString()));
  }
}
