// @dart=2.9
class OrderDetail {
  String OrderDetailID, OrderID, ItemID, ItemName, Quantity;
  OrderDetail(
      {this.OrderDetailID,
      this.OrderID,
      this.ItemID,
      this.ItemName,
      this.Quantity});

  OrderDetail.fromJSON(Map<String, dynamic> json)
      : OrderDetailID = json["OrderDetailID"].toString(),
        OrderID = json["OrderID"].toString(),
        ItemID = json["ItemID"].toString(),
        ItemName = json["ItemName"].toString(),
        Quantity = json["Quantity"].toString();
  Map toJSON() {
    return {
      'OrderDetailID': OrderDetailID,
      'OrderID': OrderID,
      'ItemID': ItemID,
      'Quantity': Quantity
    };
  }
}

class Order {
  String TableID, OrderDetailID;
  Order({this.TableID, this.OrderDetailID});

  Order.fromJSON(Map<String, dynamic> json)
      : TableID = json["TableID"].toString(),
        OrderDetailID = json["OrderDetailID"].toString();
  Map toJSON() {
    return {'TableID': TableID, 'OrderDetailID': OrderDetailID};
  }
}
