import 'package:flutter/material.dart';
import '../localedatabase/database_helper.dart';
import '../models/cart.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _totalAmount = 0;

  List<CartItem> get cartItems => _cartItems;
  double get totalAmount => _totalAmount;

  void updateCartItems(List<CartItem> items) {
    _cartItems = items;
    _updateTotalAmount();
    notifyListeners();
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
    _updateTotalAmount();
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    _updateTotalAmount();
    notifyListeners();
  }

  void updateCartItem(CartItem item) {
    int index = _cartItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _cartItems[index] = item;
      _updateTotalAmount();
      notifyListeners();
    }
  }

  void _updateTotalAmount() {
    _totalAmount = _cartItems.fold(0, (total, item) => total + (item.price * item.qty));
  }
}
