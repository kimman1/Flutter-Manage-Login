//@dart=2.9
class User {
  String id, username, password;
  User({this.id, this.username, this.password});

  User.fromJSON(Map<String, dynamic> json)
      : id = json["ID"].toString(),
        username = json["Username"].toString(),
        password = json["Password"].toString();
  Map toJSON() {
    return {'ID': id, 'Username': username, 'Password': password};
  }
}
