import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String itemkey;
  CartItem({this.price, this.quantity, this.title, this.id, this.itemkey});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      onDismissed: (dismissDirection) => cart.removeItem(itemkey),
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.all(4.0),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    "Are you sure?",
                  ),
                  content: Text("Do you wand to remove the item form cart?"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Yes'),
                    ),
                  ],
                ));
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text(
                  price.toString(),
                ),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('total price = ${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
