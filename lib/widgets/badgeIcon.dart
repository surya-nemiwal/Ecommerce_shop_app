import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Function operation;
  final Color color;
  BadgeIcon({this.icon, this.operation, this.color});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(icon: Icon(icon), onPressed: operation),
        Positioned(
          top: 5,
          right: 5,
          child: CircleAvatar(
            minRadius: 8,
            maxRadius: 8,
            child: Consumer<Cart>(
              builder: (ctx, cart, _) => Text(cart.totalProducts.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
