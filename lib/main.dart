import 'package:eccommerces_app/providers/cart_provider.dart';
import 'package:eccommerces_app/providers/categories_provider.dart';
import 'package:eccommerces_app/providers/product_provider.dart';
import 'package:eccommerces_app/providers/wishlist_provider.dart';
import 'package:eccommerces_app/screens/cart_screen.dart';
import 'package:eccommerces_app/screens/home_screen.dart';
import 'package:eccommerces_app/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'localedatabase/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CategoeriesProvider()),
        ChangeNotifierProvider(create: (ctx) => WishlistProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
    ],
      child: MaterialApp(
      title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white, // Change this to the desired color
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
      home: const MyHomePage(title: 'Home'),
    )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _cartBadgeAmount = 3;
  late bool _showCartBadge;
  Color color = Colors.red;

  int _selectedIndex = 0;

  static  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text('Order Page'),
    WishlistScreen(),
    Text('Profile Page'),
  ];
  DatabaseHelper dbHelper = DatabaseHelper();

  int? itemCount=0;




  @override
  Widget build(BuildContext context) {
    //final cartProvider = Provider.of<CartProvider>(context);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.blueAccent[700],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
        automaticallyImplyLeading: true
        ,
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()), // Replace with your CartScreen
                  );
                  },
              ),
              Positioned(
                right: 5,
                top: 5,
                child:  badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: Colors.red,
                      padding: EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(4),),
                  position: badges.BadgePosition.topEnd(top: -10, end: -12),
                  showBadge: true,
                  ignorePointer: false,
                  onTap: () {},
                  badgeContent: Text("5"),

                ),

              ),
            ],
          ),

        ],
        leading: IconButton(
          icon: Icon(Icons.menu,color: Colors.white,), // Hamburger icon
          onPressed: () {
            // Add your navigation drawer or menu functionality here
          },
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),  BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent[700], // Change selected text color here
        unselectedItemColor: Colors.grey, // Change unselected text color here
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget _shoppingCartBadge() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeAnimation: badges.BadgeAnimation.slide(
        // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
        // curve: Curves.easeInCubic,
      ),
      showBadge: _showCartBadge,
      badgeStyle: badges.BadgeStyle(
        badgeColor: color,
      ),
      badgeContent: Text(
        _cartBadgeAmount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
    );
  }
}
