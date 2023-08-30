import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../utility/json_loader.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Future<void> loadProducts() async {
    print("products.....ProductProvider...");

    try {
      final jsonLoader = JsonLoader();
      _products =
          await jsonLoader.loadProductsFromJson('assets/product_data.json');
      print("products........${_products}");
      notifyListeners();
    } catch (error) {
      // Handle error
      print("Error loading pv products: $error");

    }
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}
