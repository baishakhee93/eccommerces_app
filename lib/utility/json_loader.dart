import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/categoeri.dart';
import '../models/product.dart';

class JsonLoader {
  Future<List<Product>> loadProductsFromJson(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final jsonData = json.decode(jsonString);

      final productsJson = jsonData['product'] as List<dynamic>;
      final products = productsJson.map((item) => Product.fromJson(item)).toList();
      print("products loading products: $products");

      return products;
    } catch (error) {
      print('Error loading JSON: $error');
      throw error;
    }
  }
  Future<List<Categoeries>> loadCategoriesFromJson(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final jsonData = json.decode(jsonString);

      final categoeriesJson = jsonData['categoeries'] as List<dynamic>;

      print("categoeriess.... loading categoeriesJson: $categoeriesJson");

      final categoeries = categoeriesJson.map((item) => Categoeries.fromJson(item)).toList();
      print("categoeriess.... loading categoeries: $categoeries");

      return categoeries;
    } catch (error) {
      print('Error loading JSON: $error');
      throw error;
    }
  }
}
