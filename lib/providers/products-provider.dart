import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product-provider.dart';
import '../models/HttpException.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   category: "Shirt",
    //   price: 29.99,
    //   imageUrl:
    //       'https://assets.myntassets.com/h_1440,q_90,w_1080/v1/assets/images/17585174/2022/3/19/94cf20b0-7fff-4519-baf8-8f19a1d496aa1647696823253CAVALLObyLinenClubMenRedCasualShirt2.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   category: "Bottom Wear",
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   category: "Accessories",
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   category: "Cooking",
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String authToken;
  String userId;

  Products(this.userId, this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items.where((item) => item.isFavorite == true)];
  }

  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shop-app-39984-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; // we have all products data here on the run from TabScreen.
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          "https://shop-app-39984-default-rtdb.firebaseio.com/favoritesByUser/$userId.json?auth=$authToken");
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  } // backend stuff done.

  Future<void> addProduct(Product item) async {
    final url = Uri.parse(
        'https://shop-app-39984-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'imageUrl': item.imageUrl,
            'creatorId': userId, // this is only used here.
          }));
      _items.add(Product(
        title: item.title,
        id: json.decode(response.body)['name'],
        price: item.price,
        description: item.description,
        imageUrl: item.imageUrl,
        category: item.category,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  } // backend stuff done.

  Future<void> updateProduct(Product existingItem) async {
    int specifiedIndex =
        _items.indexWhere((item) => item.id == existingItem.id);
    final url = Uri.parse(
        'https://shop-app-39984-default-rtdb.firebaseio.com/products/${existingItem.id}.json?auth=$authToken');
    try {
      await http.patch(url,
          body: json.encode({
            'title': existingItem.title,
            'description': existingItem.description,
            'price': existingItem.price,
            'imageUrl': existingItem.imageUrl,
          }));
      _items[specifiedIndex] = Product(
          title: existingItem.title,
          id: existingItem.id,
          price: existingItem.price,
          description: existingItem.description,
          imageUrl: existingItem.imageUrl,
          category: existingItem.category);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  } // Slightly modified for updating data.

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-39984-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final indexForRevert = _items.indexWhere((prod) => prod.id == id);
    var backupForRevert = _items[indexForRevert];
    _items.removeAt(indexForRevert);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(indexForRevert, backupForRevert);
      notifyListeners();
      backupForRevert = null;
      throw HttpException("Could not delete the product.");
    }
  }

  Product searchByID(String id) {
    return items.firstWhere((item) => item.id == id);
  }
}
