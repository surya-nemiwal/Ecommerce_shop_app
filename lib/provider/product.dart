import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/FavoriteException.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool favorite = false;
  Product({this.id, this.title, this.description, this.imageUrl, this.price, this.favorite = false});
  Future<void> toggleFavorite() async {
    favorite = !favorite;
    notifyListeners();
    final url = 'https://myshop-e3b7b.firebaseio.com/products/$id.json';
    print('in toggle');
    final response = await http.patch(
      url,
      body: json.encode(
        {
          'favorite': favorite,
        },
      ),
    );
    print(response);
    if (response.statusCode >= 400) {
      favorite = !favorite;
      notifyListeners();
      throw FavoriteException();
    }
  }
}
