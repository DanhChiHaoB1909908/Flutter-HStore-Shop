import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  String category;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.category,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String authToken, String userId) async {
    var backup = isFavorite;
    final url = Uri.parse(
        "https://shop-app-39984-default-rtdb.firebaseio.com/favoritesByUser/$userId/$id.json?auth=$authToken");
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        isFavorite = backup;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = backup;
      notifyListeners();
    }
  }
}
