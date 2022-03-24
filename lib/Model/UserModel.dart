//@dart=2.9
class User {
  String id, username, password;
  User({this.id, this.username, this.password});

  User.fromJSON(Map<String, dynamic> json)
      : id = json["id"].toString(),
        username = json["username"].toString(),
        password = json["password"].toString();
  Map toJSON() {
    return {'id': id, 'username': username, 'password': password};
  }
}
