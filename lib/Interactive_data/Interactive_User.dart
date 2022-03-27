import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:manage/Model/UserModel.dart';

class Interactive_User {
  Future<List<User>> getAllUser() async {
    List<User> listUser = new List<User>.empty(growable: true);
    UserAPI.getUser().then((response) {
      Iterable list = json.decode(response.body);
      listUser = list.map((model) => User.fromJSON(model)).toList();
    });
    return listUser;
  }
}

class UserAPI {
  static String UrlAPI = 'https://localhost:44375/api/';
  static Future getUser() {
    return http.get(Uri.parse(UrlAPI + 'GetUser'));
  }

  static Future getUserById(int id) {
    return http.get(Uri.parse(UrlAPI + 'GetUser/' + id.toString()));
  }
}
