class Categoeries {
  final String id;
  final String title;
  final String imageUrl;
  final List<SubCategory> subCategories;

  Categoeries({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.subCategories,
  });

  factory Categoeries.fromJson(Map<String, dynamic> json) {
    List<dynamic> subCategoryJsonList = json['subCategoeries'];
    List<SubCategory> subCategories = subCategoryJsonList.map((subCategoryJson) {
      return SubCategory.fromJson(subCategoryJson);
    }).toList();
    return Categoeries(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      subCategories: subCategories,
    );
  }
}

class SubCategory {
  final String id;
  final String subTitle;
  final List<ProductCategoeries> products;

  SubCategory({
    required this.id,
    required this.subTitle,
    required this.products,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    List<dynamic> productJsonList = json['products'];
    List<ProductCategoeries> productsCategoery = productJsonList.map((productJson) {
      return ProductCategoeries.fromJson(productJson);
    }).toList();
    return SubCategory(
      id: json['id'],
      subTitle: json['subTitle'],
      products: productsCategoery,
    );
  }
}

class ProductCategoeries {
  final String id;
  final String name;
  final double price;
  final String image;

  ProductCategoeries({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory ProductCategoeries.fromJson(Map<String, dynamic> json) {
    return ProductCategoeries(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}
