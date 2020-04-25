import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

//  var _showFavoriteOnly = false;

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get items {
//    if (_showFavoriteOnly) {
//      return _items.where((prodItem) => prodItem.isFavourite).toList();
//    }
    return [..._items];
  }

//  void showFavoriteOnly() {
//    _showFavoriteOnly = true;
//    notifyListeners();
//  }
//
//  void showAll () {
//    _showFavoriteOnly = false;
//    notifyListeners();
//  }

  final String authToken;

  Products(this.authToken, this._items);

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shop-app-e46df.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) return;
      final List<Product> loadedData = [];
      extractData.forEach((prodId, prodData) {
        loadedData.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: prodData['isFavorite'],
        ));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shop-app-e46df.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'isFavorite': product.isFavourite,
            'price': product.price,
            'imageUrl': product.imageUrl
          }));

//          print(json.decode(response.body));
      final newProduct = Product(
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
          id: json.decode(response.body)['name']);

      _items.add(newProduct);
//    _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = 'https://shop-app-e46df.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-app-e46df.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var exitingProductData = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
//      print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, exitingProductData);
      notifyListeners();
      throw HttpException('could not delete a product');
    }
    exitingProductData = null;
  }
}
