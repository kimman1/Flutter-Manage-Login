// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manage/Model/UserModel.dart';

class Interactive_User {
  //List<User> listUser;
  Future<List<User>> getAllUser() async 
  {
    final http.Response response = await UserAPI.getUser();
    Iterable l = json.decode(response.body);
    List<User> listUser = List<User>.from(l.map((model) => User.fromJSON(model)));
    return listUser;
  }

  Future<String> getUserLogin(User user) async {
    //final http.Response response = UserAPI.getuserByUserObject(user);
    String dataResponse = "";
    var bodyvalue = user.toJSON();
    var bodydata = json.encode(bodyvalue);
    final http.Response response = await UserAPI.getuserByUserObject(user, bodydata);
    if (response.statusCode == 200) 
    {
      dataResponse = "success";
    } 
    else 
    {
      dataResponse = "failed";
    }
    //print(dataResponse);
    return dataResponse;
  }
}

class UserAPI 
  {
  static String UrlAPI = 'http://kimman.somee.com/api/';
  static Future getUser() {
    return http.get(Uri.parse(UrlAPI + 'User/GetUser'));
  }

  static Future getUserById(int id)
 {
    return http.get(Uri.parse(UrlAPI + 'User/GetUser/' + id.toString()));
  }

  static Future getuserByUserObject(User user, String bodydata) 
  {
    return http.post(Uri.parse(UrlAPI + 'User/GetUserByUser'),
        headers: 
        {
          "Content-Type": "application/json",
        },
        body: bodydata);
  }
}
