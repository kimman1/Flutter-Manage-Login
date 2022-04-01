// @dart=2.9
class Item {
  String ItemID,CategoryID, ItemName, UnitPrice;
  Item({this.ItemID,this.CategoryID, this.ItemName, this.UnitPrice});

  Item.fromJSON(Map<String, dynamic> json)
      : ItemID = json["ItemID"].toString(),
       CategoryID = json["CategoryID"].toString(),
        ItemName = json["ItemName"].toString(),
        UnitPrice = json["UnitPrice"].toString();
  Map toJSON() {
    return {'ItemID': ItemID, 'CategoryID': CategoryID, 'ItemName': ItemName, 'UnitPrice': UnitPrice};
  }
}
