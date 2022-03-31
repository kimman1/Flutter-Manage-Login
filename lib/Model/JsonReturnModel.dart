//@dart=2.9
class JsonReturnModel {
  String statusCode, message;
  JsonReturnModel({this.statusCode, this.message});

  JsonReturnModel.fromJSON(Map<String, dynamic> json)
      : statusCode = json["statusCode"].toString(),
        message = json["message"].toString();

  // ignore: empty_constructor_bodies
  Map toJson() {
    return {'statusCode': statusCode, 'message': message};
  }
}