import 'package:eccommerces_app/models/categoeri.dart';
import 'package:eccommerces_app/models/wishlistItem.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  int _wishlistItemCount = 0;
  List<WishListItem> _wishlistItems = [];

  int get wishlistItemCount => _wishlistItemCount;
  List<WishListItem> get wishlistItems => _wishlistItems;

  void updateWishlistItemCount(int newCount) {
    _wishlistItemCount = newCount;
    notifyListeners();
  }

  void addToWishlist(WishListItem item) {
    _wishlistItems.add(item);
    _wishlistItemCount = _wishlistItems.length;
    notifyListeners();
  }

  void removeFromWishlist(WishListItem item) {
    _wishlistItems.remove(item);
    _wishlistItemCount = _wishlistItems.length;
    notifyListeners();
  }

  bool isProductInWishlist(String productId) {
    return _wishlistItems.any((product) => product.productId == productId);
  }

  void setWishlistItems(List<WishListItem> items) {
    _wishlistItems = items;
    _wishlistItemCount = _wishlistItems.length;
    notifyListeners();
  }

  void removeWishlistItem(String productId) {
    _wishlistItems.removeWhere((product) => product.productId == productId);
    _wishlistItemCount = _wishlistItems.length;
    notifyListeners();
  }

  void addWishlistItem(String uniqueId,String id, String imageUrl, double price, String name, SubCategory? selectedSubCategory) {
    WishListItem product=new WishListItem(id: uniqueId, productId: id,name: name, price: price, image: imageUrl, category: selectedSubCategory!.subTitle.toString());
    _wishlistItems.add(product);
    _wishlistItemCount = _wishlistItems.length;
    notifyListeners();
  }
}
