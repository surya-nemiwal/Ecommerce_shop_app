import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};
  int totalProducts = 0;

  void addItem(String id, String title, double price) {
    if (_cart.containsKey(id)) {
      _cart[id] = CartItem(
        id: _cart[id].id,
        title: _cart[id].title,
        price: _cart[id].price,
        quantity: _cart[id].quantity + 1,
      );
    } else {
      _cart[id] = CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      );
    }
    totalProducts += 1;
    notifyListeners();
  }

  double get allTotal {
    double total = 0;
    _cart.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  Map<String, CartItem> get cartItems {
    return {..._cart};
  }

  void removeItem(String id) {
    totalProducts -= _cart[id].quantity;
    _cart.remove(id);
    notifyListeners();
  }

  void clear() {
    _cart = {};
    totalProducts = 0;
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_cart.containsKey(id)) {
      return;
    } else if (_cart[id].quantity > 1) {
      _cart[id] = CartItem(
        id: _cart[id].id,
        title: _cart[id].title,
        price: _cart[id].price,
        quantity: _cart[id].quantity - 1,
      );
    } else {
      _cart.remove(id);
    }
    totalProducts -= 1;
    notifyListeners();
  }
}
