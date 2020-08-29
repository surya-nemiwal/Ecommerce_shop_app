import 'package:flutter/material.dart';

import '../screens/products_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            height: 100.0,
            alignment: Alignment.centerLeft,
            child: Text(
              'MY Shop!',
              style: TextStyle(fontSize: 25),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop Now'),
            onTap:() => Navigator.of(context).pushReplacementNamed(ProductsOverview.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Manage Products'),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName),
          ),
           Divider(),
        ],
      ),
    );
  }
}
