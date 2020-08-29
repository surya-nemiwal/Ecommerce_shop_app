import '../screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetails.rountName,
        arguments: product.id,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            leading: Consumer<Product>(
              builder: (ctx, product, child) {
                return IconButton(
                  icon: Icon(
                    product.favorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => product.toggleFavorite(),
                );
              },
            ),
            title: Text(
              product.title,
              style: TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  cart.addItem(
                    product.id,
                    product.title,
                    product.price,
                  );
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item added to cart'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'undo',
                        onPressed: () => cart.removeSingleItem(product.id),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
