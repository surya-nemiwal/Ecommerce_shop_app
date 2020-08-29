import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart' show Cart;
import '../provider/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'CartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.cartItems.values.toList();
    final cartItemKeys = cart.cartItems.keys.toList();
    final ordersProvider = Provider.of<Orders>(context, listen: false);
    final total = cart.allTotal;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text("Your Cart is empty!!!"),
            )
          : Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Text('Total'),
                        Spacer(),
                        Chip(
                          backgroundColor: Theme.of(context).primaryColor,
                          label: Text(
                            total.toStringAsFixed(2),
                          ),
                        ),
                        FlatButton(
                          child: Text('Order Now'),
                          onPressed: () {
                            ordersProvider.addOrder(total, cartItems);
                            cart.clear();
                          },
                          textColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      return CartItem(
                        title: cartItems[i].title,
                        price: cartItems[i].price,
                        quantity: cartItems[i].quantity,
                        itemkey: cartItemKeys[i],
                        id: cartItems[i].id,
                      );
                    },
                    itemCount: cartItems.length,
                  ),
                ),
              ],
            ),
    );
  }
}
