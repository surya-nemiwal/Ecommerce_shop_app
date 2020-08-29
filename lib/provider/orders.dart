import 'package:flutter/foundation.dart';
import './cart.dart';

class Order {
  final String id;
  final double total;
  final DateTime date;
  final List<CartItem> orders;
  Order({this.date, this.id, this.total, this.orders});
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  void addOrder(double total, List<CartItem> cartItems) {
    _orders.insert(
      0,
      Order(
        date: DateTime.now(),
        id: DateTime.now().toString(),
        total: total,
        orders: cartItems,
      ),
    );
    notifyListeners();
  }

  List<Order> get getOrders {
    return [..._orders];
  }
}
