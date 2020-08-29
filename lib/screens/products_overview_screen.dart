import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../provider/products.dart';
import '../widgets/product_item.dart';
import '../widgets/badgeIcon.dart';
import '../widgets/main_drawer.dart';

enum Choice {
  ShowOnlyFavorites,
  ShowAll,
}

class ProductsOverview extends StatefulWidget {
  static const routeName = '/products-overview';
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool showfavs = false;
  bool isFirstTime = true;
  bool areProductsLoading = false;

  // @override
  // void initState() {
    
  // }
  @override
  void didChangeDependencies() {
    if (isFirstTime) {
      isFirstTime = false;
      getProducts();
      print('in is first time');
    }
    super.didChangeDependencies();
  }

  Future<void> getProducts() async {
    setState(() {
      areProductsLoading = true;
    });
    await Provider.of<Products>(context).getAndSetProducts();
    setState(() {
      areProductsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = showfavs ? productsProvider.getFavItems : productsProvider.getItems;
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              size: 35,
            ),
            onSelected: (value) {
              if (value == Choice.ShowOnlyFavorites) {
                setState(() {
                  showfavs = true;
                });
              } else {
                setState(() {
                  showfavs = false;
                });
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: Choice.ShowOnlyFavorites,
                child: Text('Only Favorites'),
              ),
              PopupMenuItem(
                value: Choice.ShowAll,
                child: Text('Show all'),
              ),
            ],
          ),
          BadgeIcon(
            icon: Icons.shopping_cart,
            operation: () => Navigator.of(context).pushNamed(CartScreen.routeName),
          ),
        ],
      ),
      body: areProductsLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: products[i],
                  child: ProductItem(),
                ),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
              ),
            ),
      drawer: MainDrawer(),
    );
  }
}
