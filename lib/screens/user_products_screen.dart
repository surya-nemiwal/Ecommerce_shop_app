import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../provider/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/main_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    // final productsProvider = Provider.of<Products>(context);
    final products =  Provider.of<Products>(context).getItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          itemBuilder: (ctx, i) => UserProductItem(
            products[i].id,
            products[i].title,
            products[i].imageUrl,
          ),
          itemCount: products.length,
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
