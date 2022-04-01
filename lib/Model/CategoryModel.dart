// @dart=2.9
class Category {
  String CategoryID, CategoryName, Description;
  Category({this.CategoryID, this.CategoryName, this.Description});

  Category.fromJSON(Map<String, dynamic> json)
      : CategoryID = json["CategoryID"].toString(),
        CategoryName = json["CategoryName"].toString(),
        Description = json["Description"].toString();
  Map toJSON() {
    return {'CategoryID': CategoryID, 'CategoryName': CategoryName, 'Description': Description};
  }
}
