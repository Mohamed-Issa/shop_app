import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavoriteStatus() async {
    final oldState = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://shop-app-e46df.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(url,
          body: json.encode(({
            'isFavorite': isFavourite,
          })));
      if (response.statusCode >= 400) {
        isFavourite = oldState;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldState;
      notifyListeners();
    }
  }
}
