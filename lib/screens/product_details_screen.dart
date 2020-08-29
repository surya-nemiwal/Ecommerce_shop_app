import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductDetails extends StatelessWidget {
  static const rountName = 'PrductDetails';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final product = Provider.of<Products>(context).getItem(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Image.network(product.imageUrl,height: 300,width: double.infinity,fit: BoxFit.cover,),
            Text(product.title),
            Text(
              product.description,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
