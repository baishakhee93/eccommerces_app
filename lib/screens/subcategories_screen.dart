
import 'package:eccommerces_app/models/product.dart';
import 'package:eccommerces_app/models/wishlistItem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../localedatabase/database_helper.dart';
import '../models/cart.dart';
import '../models/categoeri.dart';
import '../providers/categories_provider.dart';
import '../providers/wishlist_provider.dart';
class SubCategoriesScreen extends StatefulWidget {
  final List<SubCategory> subCategories;

  SubCategoriesScreen({required this.subCategories});

  @override
  _SubCategoriesScreenState createState() =>
      _SubCategoriesScreenState(subCategories);
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final List<SubCategory> subCategories;

  _SubCategoriesScreenState(this.subCategories);
  late WishlistProvider _wishlistProvider;
  DatabaseHelper dbHelper = DatabaseHelper();

  SubCategory? selectedSubCategory;
  WishListItem? wishListItem;
  void addToCart(BuildContext context, ProductCategoeries product, String subTitle, ) async {
    CartItem cartItem = CartItem(
      id: DateTime.now().toString(),
      productId: product.id,
      name: product.name,
      price: product.price,
      image: product.image,
      category: subTitle,
      qty: 1,
    );

    await dbHelper.insertCartItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to Cart')),
    );
  }
  Future<void> fetchWishlistItems() async {
    try {
      List<WishListItem> fetchedWishlistItems = await dbHelper.getAllWishlistItems();
      int wishlistItemCount = fetchedWishlistItems.length;

      _wishlistProvider.updateWishlistItemCount(wishlistItemCount);
    } catch (e) {
      print('Error fetching wishlist items: $e');
    }
  }

  void addToWishlist(String uniqueId,String id, String imageUrl, double price, String name, SubCategory? selectedSubCategory) async {
    WishListItem item=new WishListItem(id: uniqueId, productId: id,name: name, price: price, image: imageUrl, category: selectedSubCategory!.subTitle.toString());

    await dbHelper.insertWishlistItem(item);
    fetchWishlistItems();
  }

  void removeFromWishlist(WishListItem item) async {
    await dbHelper.deleteWishlistItem(item.id);
    fetchWishlistItems();
  }


  @override
  void initState() {
    super.initState();
    _wishlistProvider = context.read<WishlistProvider>();
    fetchWishlistItems();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Products',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent[700],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSubCategory = null; // Select "All"
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedSubCategory == null
                          ? Colors.blueAccent[700] // Change to your desired color
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child:  Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedSubCategory == "All"
                              ? Colors.blueAccent[700] // Change to your desired color
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "All",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                for (var subCategory in subCategories)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSubCategory = subCategory;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedSubCategory == subCategory
                            ? Colors.blueAccent[700] // Change to your desired color
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              subCategory.subTitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (selectedSubCategory == null)
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7, // Adjust the height as needed
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                  ),
                  shrinkWrap: true, // Important to make it scrollable within SingleChildScrollView
                  itemCount: subCategories
                      .map<int>((category) => category.products.length)
                      .reduce((a, b) => a + b), // Total number of products
                  itemBuilder: (context, index) {
                    var categoryIndex = 0;
                    var productIndex = index;
                    for (var category in subCategories) {
                      if (productIndex < category.products.length) {
                        break;
                      }
                      productIndex -= category.products.length;
                      categoryIndex++;
                    }
                    var product = subCategories[categoryIndex].products[productIndex];
                    bool isWishlist = _wishlistProvider.isProductInWishlist(product.id); // Check if the product is in the wishlist

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/${product.image}',
                              height: 120,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 2.0),
                                  child: Text(
                                    'Rs. ${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 2.0),
                                  child:    IconButton(
                                    icon: isWishlist ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border),
                                    onPressed: () async {
                                      final now = DateTime.now();
                                      final formatter = DateFormat('yyyyMMddHHmmss'); // Define the date format
                                      final formattedDate = formatter.format(now); // Format the current date and time

                                      // You can append other identifiers or random numbers if needed
                                      final uniqueId = 'ID_$formattedDate';

                                      if (isWishlist) {
                                        // Remove from wishlist
                                        _wishlistProvider.removeWishlistItem(product.id);


                                      } else {
                                        addToWishlist(uniqueId,product.id,product.image,product.price,product.name,selectedSubCategory);
                                        // Add to wishlist
                                        _wishlistProvider.addWishlistItem(uniqueId,product.id,product.image,product.price,product.name,selectedSubCategory);
                                      }
                                    },
                                  ),
                                ),

                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 2.0),
                                  child:  IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      // Handle button press
                                      addToCart(context,product,selectedSubCategory!.subTitle);
                                    },
                                    icon: Icon(Icons.add_circle_outlined),color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),

                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // Aligns the button to the right
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Handle button press
                                      addToCart(context,product,selectedSubCategory!.subTitle);

                                    },
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          if (selectedSubCategory != null)
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                    ),
                    shrinkWrap: true, // Important to make it scrollable within Column
                    itemCount: selectedSubCategory!.products.length,
                    itemBuilder: (context, index) {
                      var product = selectedSubCategory!.products[index];


                      bool isWishlist = _wishlistProvider.isProductInWishlist(product.id); // Check if the product is in the wishlist

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Image.asset(
                                'assets/images/${product.image}',
                                height: 120,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 2.0),
                                    child: Text(
                                      'Rs. ${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 2.0),
                                    child:    IconButton(
                                      icon: isWishlist ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border),
                                      onPressed: () async {
                                        final now = DateTime.now();
                                        final formatter = DateFormat('yyyyMMddHHmmss'); // Define the date format
                                        final formattedDate = formatter.format(now); // Format the current date and time

                                        // You can append other identifiers or random numbers if needed
                                        final uniqueId = 'ID_$formattedDate';

                                        if (isWishlist) {
                                          // Remove from wishlist
                                          _wishlistProvider.removeWishlistItem(product.id);


                                        } else {
                                          addToWishlist(uniqueId,product.id,product.image,product.price,product.name,selectedSubCategory);
                                          // Add to wishlist
                                          _wishlistProvider.addWishlistItem(uniqueId,product.id,product.image,product.price,product.name,selectedSubCategory);
                                        }
                                      },
                                    ),
                                    ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 2.0),
                                    child:  IconButton(
                                      iconSize: 40,
                                      onPressed: () {
                                        // Handle button press
                                        addToCart(context,product,selectedSubCategory!.subTitle);
                                      },
                                      icon: Icon(Icons.add_circle_outlined),color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

