import 'package:flutter/material.dart';
import '../localedatabase/database_helper.dart';
import '../models/cart.dart'; // Import your CartItem class

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> cartItems;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    cartItems = [];

    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      // Fetch cart items using the appropriate method from your DatabaseHelper class
      List<CartItem> fetchedCartItems = await dbHelper.getAllCartItems();
      double total = 0;
      for (var cartItem in fetchedCartItems) {
        total += cartItem.price * cartItem.qty;
      }

      setState(() {
        cartItems = fetchedCartItems; // Update cartItems with fetched data
        totalAmount = total;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
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
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final totalForItem = cartItem.price * cartItem.qty;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: cartItem.image != null
                                  ? Container(
                                      height: 80,
                                      width:
                                          100, // You can adjust the width as needed
                                      child: Image.asset(
                                        'assets/images/${cartItem.image}',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                          )),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              'Rs. ${cartItem.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline_sharp),
                                  onPressed: () async {
                                    if (cartItem.qty > 1) {
                                      cartItem.qty--;
                                      DatabaseHelper dbHelper =
                                          DatabaseHelper();
                                      await dbHelper.updateCartItem(cartItem);
                                      fetchCartItems();
                                    }
                                  },
                                ),
                                Text(cartItem.qty.toString()),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline_rounded),
                                  onPressed: () async {
                                    cartItem.qty++;
                                    DatabaseHelper dbHelper = DatabaseHelper();
                                    await dbHelper.updateCartItem(cartItem);
                                    fetchCartItems();
                                  },
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                child: Container(
                alignment: Alignment.center,
                            child: Text(
                              cartItem.name ?? 'Default Name',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              'Total: Rs. ${totalForItem.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                DatabaseHelper dbHelper = DatabaseHelper();
                                await dbHelper.deleteCartItem(cartItem.id);
                                fetchCartItems();
                              },
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Rs. ${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement your checkout logic here
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
