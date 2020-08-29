import 'package:DailyMenu/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart';

import '../widgets/main_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    final ordersData = ordersProvider.getOrders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, i) => OrderItem(
            products: ordersData[i].orders,
            total: ordersData[i].total,
            date: ordersData[i].date,
          ),
          itemCount: ordersData.length,
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
