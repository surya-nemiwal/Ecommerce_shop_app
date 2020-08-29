import 'package:flutter/material.dart';
import 'dart:math';
import '../provider/cart.dart';

class OrderItem extends StatefulWidget {
  final List<CartItem> products;
  final double total;
  final DateTime date;
  OrderItem({this.products, this.date, this.total});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var showmore = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            widget.total.toString(),
          ),
          subtitle: Text(
            widget.date.toString(),
          ),
          trailing: IconButton(
            icon: Icon(
              showmore ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () => setState(() => showmore = !showmore),
          ),
        ),
        if (showmore)
          Container(
            height: min(widget.products.length * 16.0 + 10, 100),
            child: ListView.builder(
              itemBuilder: (ctx, i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.products[i].title),
                  Text('${widget.products[i].price} x ${widget.products[i].quantity}'),
                ],
              ),
              itemCount: widget.products.length,
            ),
          )
      ],
    );
  }
}
