
import 'package:eccommerces_app/models/wishlistItem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cart.dart';

class DatabaseHelper {
  static final _databaseName = 'eccommerces_database.db';
  static final _databaseVersion = 3;

  // Define the table names and column names
  static final cartTable = 'cart';
  static final columnId = 'id';
  static final columnProductId = 'productId';
  static final columnName = 'name';
  static final columnPrice = 'price';
  static final columnImage = 'image';
  static final columnCategory = 'category';
  static final columnQty = 'qty';// Define the table names and column names


  static final wishlistTable = 'wishlist';


  // Singleton instance
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $cartTable(
        $columnId TEXT PRIMARY KEY,
        $columnProductId TEXT,
        $columnName TEXT,
        $columnPrice REAL,
        $columnImage TEXT,
        $columnCategory TEXT,
        $columnQty INTEGER DEFAULT 1
      )
    ''');
    await db.execute('''
      CREATE TABLE $wishlistTable(
        $columnId TEXT PRIMARY KEY,
        $columnProductId TEXT,
        $columnName TEXT,
        $columnPrice REAL,
        $columnImage TEXT,
        $columnCategory TEXT,
        $columnQty INTEGER DEFAULT 1
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
    //  await db.execute('ALTER TABLE $cartTable ADD COLUMN $columnQty INTEGER DEFAULT 1');

      await db.execute('''
      CREATE TABLE $wishlistTable(
        $columnId TEXT PRIMARY KEY,
        $columnProductId TEXT,
        $columnName TEXT,
        $columnPrice REAL,
        $columnImage TEXT,
        $columnCategory TEXT
      )
    ''');
    }
  }

// Rest of your methods
  Future<void> insertCartItem(CartItem cartItem) async {
    final db = await database;
    await db.insert(
      'cart',
      cartItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartItem>> getAllCartItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (index) {
      return CartItem(
        id: maps[index]['id'],
        productId: maps[index]['productId'],
        name: maps[index]['name'],
        price: maps[index]['price'],
        image: maps[index]['image'],
        category: maps[index]['category'],
        qty: maps[index]['qty'],
      );
    });
  }

  Future<void> updateCartItem(CartItem cartItem) async {
    final Database db = await database;

    await db.update(
      'cart',
      cartItem.toMap(),
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );
  }
  Future<int?> getCartItemCount() async {
    final Database db = await database;
    final int? count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM cart'),
    );
    return count;
  }


  Future<void> deleteCartItem(String cartItemId) async {
    final db = await database; // Use your dbHelper instance here
    await db.delete('cart', where: 'id = ?', whereArgs: [cartItemId]);
  }
  Future<void> insertWishlistItem(WishListItem wishListItem) async {
    final db = await database;
    await db.insert(
      'wishlist',
      wishListItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWishlistItem(String cartItemId) async {
    final db = await database; // Use your dbHelper instance here
    await db.delete('wishlist', where: 'id = ?', whereArgs: [cartItemId]);
  }

  Future<List<WishListItem>> getAllWishlistItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wishlist');

    return List.generate(maps.length, (index) {
      return WishListItem(
        id: maps[index]['id'],
        productId: maps[index]['productId'],
        name: maps[index]['name'],
        price: maps[index]['price'],
        image: maps[index]['image'],
        category: maps[index]['category'],
      );
    });
  }
}
