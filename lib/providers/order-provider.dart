import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart-provider.dart';

class Order with ChangeNotifier {
  List<OrderItem> _order = [];

  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._order);

  List<OrderItem> get OrderList {
    return [..._order];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://shop-app-39984-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractOrdersData =
          json.decode(response.body) as Map<String, dynamic>;
      // if(extractOrdersData == null) {
      //   return;
      // }
      List<OrderItem> loadedOrdersData = [];
      extractOrdersData.forEach((orderId, orderData) {
        loadedOrdersData.add(OrderItem(
          id: orderId,
          dateTime: DateTime.parse(orderData['dateTime']),
          TotalAmount: orderData['TotalAmount'],
          CartItemList: (orderData['cartItemList'] as List<dynamic>)
              .map((CIfromServer) => CartItem(
                  id: CIfromServer['id'],
                  price: CIfromServer['price'],
                  imageUrl: CIfromServer['imageUrl'],
                  title: CIfromServer['title'],
                  quantity: CIfromServer['quantity']))
              .toList(),
        ));
      });
      _order = loadedOrdersData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(double totalPrice, List<CartItem> CartItems) async {
    final url = Uri.parse(
        'https://shop-app-39984-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'TotalAmount': totalPrice,
            'dateTime': timestamp.toIso8601String(),
            'cartItemList': CartItems.map((CI) => {
                  'id': CI.id,
                  'price': CI.price,
                  'title': CI.title,
                  'quantity': CI.quantity,
                  'imageUrl': CI.imageUrl,
                }).toList(),
          }));
      _order.add(OrderItem(
        id: json.decode(response.body)['name'],
        dateTime: timestamp,
        CartItemList: CartItems,
        TotalAmount: totalPrice,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

class OrderItem {
  final String id;
  final DateTime dateTime;
  final List<CartItem> CartItemList;
  final double TotalAmount;

  OrderItem({this.id, this.CartItemList, this.dateTime, this.TotalAmount});
}
