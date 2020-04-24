import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, i) => Column(
            children: <Widget>[
              UserProductItem(
                productData.items[i].id,
                productData.items[i].title,
                productData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
