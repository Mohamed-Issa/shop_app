import 'package:flutter/foundation.dart';

class CardItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CardItem({this.id, this.title, this.price, this.quantity});
}

class Card with ChangeNotifier {
  Map<String, CardItem> _items;

  Map<String, CardItem> get items {
    return {..._items};
  }

  void addItem(String title, double price, String productId) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingCardItem) =>
          CardItem(id: existingCardItem.id,
              title: existingCardItem.title,
              price: existingCardItem.price,
              quantity: existingCardItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
              () =>
              CardItem(
                  id: DateTime.now().toString(),
                  price: price,
                  title: title,
                  quantity: 1));
    }
  }
}
