import 'package:sqflite/sqflite.dart';

import '../database/db_helper.dart';
import '../models/product.dart';

class ProductService {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insertProduct(Product product) async {
    final db = await _dbHelper.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        supplierId: maps[i]['supplier_id'] as int,
        description: maps[i]['description'] as String,
        price: (maps[i]['price'] as num).toDouble(),
        quantity: maps[i]['quantity'] as int,
      );
    });
  }

  Future<int> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('products', where: 'id=?', whereArgs: [id]);
  }

  Future<int> getProductCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getLowStockProducts() async {
    final db = await _dbHelper.database;

    return await db.query(
      'products',
      where: 'quantity <= ?',
      whereArgs: [5], // threshold
    );
  }
}
