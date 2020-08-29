import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool favorite = false;
  Product({this.id, this.title, this.description, this.imageUrl, this.price,this.favorite = false});
  void toggleFavorite() {
    favorite = !favorite;
    notifyListeners();
  }
}
