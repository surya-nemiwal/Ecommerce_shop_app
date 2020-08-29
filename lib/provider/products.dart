import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/DeleteException.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  //  = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  List<Product> get getItems {
    return [..._items];
  }

  List<Product> get getFavItems {
    return _items.where((product) => product.favorite).toList();
  }

  Product getItem(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> getAndSetProducts() async {
    var url = 'https://myshop-e3b7b.firebaseio.com/products.json';
    var response = await http.get(url);
    Map<String, dynamic> productsMap = json.decode(response.body);
    _items = [];
    productsMap.forEach(
      (key, product) {
        // print(key);
        // print(product);
        _items.add(
          Product(
            id: key,
            price: product['price'],
            title: product['title'],
            description: product['description'],
            imageUrl: product['imageUrl'],
            favorite: product['favorite'],
          ),
        );
      },
    );
  }

  Future<void> saveItem(Product product) async {
    // var prodIndex = _items.indexWhere((element) => element.id == product.id);
    if (product.id == null) {
      print('in add new product');
      const url = 'https://myshop-e3b7b.firebaseio.com/products.json';
      try {
        final resopnse = await http.post(
          url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'favorite': product.favorite,
          }),
        );
        final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(resopnse.body)['name'],
        );
        _items.add(newProduct);
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      print('in edit a product');
      final url = 'https://myshop-e3b7b.firebaseio.com/products/${product.id}.json';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'favorite': product.favorite,
          },
        ),
      );
      var prodIndex = _items.indexWhere((element) => element.id == product.id);
      _items[prodIndex] = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        favorite: product.favorite,
      );
    }
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    final url = 'https://myshop-e3b7b.firebaseio.com/products/$id.json';
    var deletedProductIndex = _items.indexWhere((element) => element.id == id);
    var deletedProduct = _items[deletedProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(deletedProductIndex, deletedProduct);
      notifyListeners();
      throw DeleteException;
    }
    
  }
}
