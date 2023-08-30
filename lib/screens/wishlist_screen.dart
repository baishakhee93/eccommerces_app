import 'package:eccommerces_app/models/wishlistItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart'; // Import your WishlistProvider class
import '../localedatabase/database_helper.dart'; // Import your DatabaseHelper class

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late WishlistProvider _wishlistProvider;
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _wishlistProvider = context.read<WishlistProvider>();
    fetchWishlistItems();
  }
  Future<void> fetchWishlistItems() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      List<WishListItem> fetchedWishlistItems = await dbHelper.getAllWishlistItems();
      _wishlistProvider.setWishlistItems(fetchedWishlistItems.cast<WishListItem>());
    } catch (e) {
      print('Error fetching wishlist items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: Text('Wishlist'),
      ),*/
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          List<WishListItem> wishlistItems = wishlistProvider.wishlistItems;

          return  GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
            ),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              WishListItem wishlistItem = wishlistItems[index];
              print("wishlistItem......name..."+wishlistItem.name);
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
                        'assets/images/${wishlistItem.image}',
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
                                wishlistItem.name,
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
                              'Rs. ${wishlistItem.price.toStringAsFixed(2)}',
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
                            child:   IconButton(
                              icon: Icon(Icons.favorite),
                              color: Colors.red, // Change the color based on whether item is in wishlist or not
                              onPressed: () async {
                                // Remove the item from wishlist
                                await dbHelper.deleteWishlistItem(wishlistItem.id);
                                fetchWishlistItems();
                              },
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.only(left: 8.0, bottom: 2.0),
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                // Handle button press
                                addToCart(context,wishlistItem,wishlistItem.category);
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
          );
        },
      ),
    );
  }



  void addToCart(BuildContext context, WishListItem product, String subTitle, ) async {
    CartItem cartItem = CartItem(
      id: DateTime.now().toString(),
      productId: product.productId,
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
}
