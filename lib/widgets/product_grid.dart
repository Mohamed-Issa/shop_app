import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prodect_item.dart';
import '../providers/products.dart';

class ProductWidget extends StatelessWidget {
  final bool showOnlyFavorite;
  ProductWidget(this.showOnlyFavorite);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showOnlyFavorite ? productData.favoriteItem :  productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
//            products[index].id,
//            products[index].title,
//           products[index].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }
}
