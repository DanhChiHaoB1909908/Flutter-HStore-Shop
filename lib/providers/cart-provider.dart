import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get cart_items {
    return {..._items};
  }

  int get cartItemsCount {
    return _items.length;
  }

  double get totalAmount {
    double p = 0.0;
    _items.forEach((id, CartItem) {
      p += (CartItem.quantity * CartItem.price);
    });
    return p;
  }

  void removeSingleItemQuantity(String id) {
    if(!_items.containsKey(id)) {
      return;
    }
    if(_items[id].quantity > 1) {
      _items[id].quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void addCartItems(String id, String title, double price, String imageUrl) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
              (selectedCartItem) =>
              CartItem(
                  id: selectedCartItem.id,
                  title: selectedCartItem.title,
                  price: selectedCartItem.price,
                  quantity: selectedCartItem.quantity + 1,
                  imageUrl: selectedCartItem.imageUrl,
              ));
    } else {
      _items.putIfAbsent(
          id,
              () =>
              CartItem(
                id: id,
                title: title,
                price: price,
                quantity: 1,
                imageUrl: imageUrl,
              ));
    }
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;
  final String imageUrl;

  CartItem({this.id, this.title, this.price, this.quantity, this.imageUrl});
}
