//@dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:manage/Model/JsonReturnModel.dart';
import 'package:manage/Model/OrderModel.dart';

class InteractiveOrder {
  Future<Order> getOrderByOrderID(String id) async {
    final http.Response response = await OrderAPI.getOrderByID(id);
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    Order jsonResult = Order.fromJSON(jsonMap);
    return jsonResult;
  }

  Future<List<JsonReturnModel>> createOrder(List<Order> od) async {
    List<JsonReturnModel> listReturn = [];
    try {
      for (Order i in od) {
        var bodyvalue = i.toJSON();
        var bodydata = json.encode(bodyvalue);
        final http.Response response = await OrderAPI.createOrder(bodydata);
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
        listReturn.add(jsonResult);
        return listReturn;
      }
    } catch (e) {
      JsonReturnModel jsonResult = JsonReturnModel();

      if (e is SocketException) {
        jsonResult.statusCode = "500";
        jsonResult.message = "Socket exception error";
        listReturn.add(jsonResult);
      } else if (e is TimeoutException) {
        jsonResult.statusCode = "408";
        jsonResult.message = "Time Out";
        listReturn.add(jsonResult);
      } else if (e is HttpException) {
        jsonResult.statusCode = "ERR_CODE";
        jsonResult.message = "Http Exception";
        listReturn.add(jsonResult);
      } else {
        jsonResult.statusCode = "Unknow";
        jsonResult.message = "Unknow";
        listReturn.add(jsonResult);
      }
      return listReturn;
    }
  }
}

class InteractiveOrderDetail {
  Future<Order> getOrderByOrderID(String id) async {
    final http.Response response = await OrderAPI.getOrderByID(id);
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    Order jsonResult = Order.fromJSON(jsonMap);
    return jsonResult;
  }

  Future<List<JsonReturnModel>> createListOrderDetail(
      List<OrderDetail> odd) async {
    List<JsonReturnModel> listReturn = [];
    try {
      for (OrderDetail i in odd) {
        var bodyvalue = i.toJSON();
        var bodydata = json.encode(bodyvalue);
        final http.Response response =
            await OrderAPI.createOrderDetail(bodydata);
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
        listReturn.add(jsonResult);
        return listReturn;
      }
    } catch (e) {
      JsonReturnModel jsonResult = JsonReturnModel();

      if (e is SocketException) {
        jsonResult.statusCode = "500";
        jsonResult.message = "Socket exception error";
        listReturn.add(jsonResult);
      } else if (e is TimeoutException) {
        jsonResult.statusCode = "408";
        jsonResult.message = "Time Out";
        listReturn.add(jsonResult);
      } else if (e is HttpException) {
        jsonResult.statusCode = "ERR_CODE";
        jsonResult.message = "Http Exception";
        listReturn.add(jsonResult);
      } else {
        jsonResult.statusCode = "Unknow";
        jsonResult.message = "Unknow";
        listReturn.add(jsonResult);
      }
      return listReturn;
    }
  }

  Future<List<JsonReturnModel>> createOrderDetail(OrderDetail odd) async {
    List<JsonReturnModel> listReturn = [];
    try {
      var bodyvalue = odd.toJSON();
      var bodydata = json.encode(bodyvalue);
      final http.Response response = await OrderAPI.createOrderDetail(bodydata);
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      JsonReturnModel jsonResult = JsonReturnModel.fromJSON(jsonMap);
      listReturn.add(jsonResult);
      return listReturn;
    } catch (e) {
      JsonReturnModel jsonResult = JsonReturnModel();

      if (e is SocketException) {
        jsonResult.statusCode = "500";
        jsonResult.message = "Socket exception error";
        listReturn.add(jsonResult);
      } else if (e is TimeoutException) {
        jsonResult.statusCode = "408";
        jsonResult.message = "Time Out";
        listReturn.add(jsonResult);
      } else if (e is HttpException) {
        jsonResult.statusCode = "ERR_CODE";
        jsonResult.message = "Http Exception";
        listReturn.add(jsonResult);
      } else {
        jsonResult.statusCode = "Unknow";
        jsonResult.message = "Unknow";
        listReturn.add(jsonResult);
      }
      return listReturn;
    }
  }
}

class OrderAPI {
  static String UrlAPI = 'http://kimman.somee.com/api/';

  static Future getOrderByID(String id) {
    return http.get(Uri.parse(UrlAPI + 'Order/GetOrderByID/$id'));
  }

  static Future getItemByCategoryID(int CategoryID) {
    return http.get(Uri.parse(UrlAPI +
        'Item/GetItemByCategoryID?CategoryID=' +
        CategoryID.toString()));
  }

  static Future EditItem(String bodydata) {
    return http.put(Uri.parse(UrlAPI + 'Item/PutItem'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }

  static Future createOrder(String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'Order/CreateOrder'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }

  static Future createOrderDetail(String bodydata) {
    return http.post(Uri.parse(UrlAPI + 'OrderDetail/CreateOrderDetail'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: bodydata);
  }

  static Future deleteItem(String ItemID) {
    return http.delete(
      Uri.parse(UrlAPI + 'Item/DeleteItem/$ItemID'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
  }
}
