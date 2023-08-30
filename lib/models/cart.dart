class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String image;
  final String category;
  late  int qty;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.qty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
      'qty': qty,
    };
  }
}