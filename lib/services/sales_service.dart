import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/cart_item.dart';

class SalesService {
  final DBHelper _dbHelper = DBHelper();

  // 💾 SAVE SALE (FIXED)
  Future<void> saveSale(
    String name,
    String phone,
    List<CartItem> cart,
    double total,
  ) async {
    final db = await _dbHelper.database;

    int saleId = await db.insert('sales', {
      'customer_name': name,
      'phone': phone,
      'date': DateTime.now().toString(),
      'total_amount': total,
    });

    for (var item in cart) {
      await db.insert('sales_items', {
        'sale_id': saleId,
        'product_id': item.product.id,
        'quantity': item.quantity,
        'price': item.product.price,
      });

      await db.rawUpdate(
        '''
        UPDATE products 
        SET quantity = quantity - ? 
        WHERE id = ?
        ''',
        [item.quantity, item.product.id],
      );
    }
  }

  // 📊 SALES COUNT
  Future<int> getSalesCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sales');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // 💰 TODAY SALES TOTAL (🔥 FIXED PROPERLY)
  Future<double> getTodaySalesTotal() async {
    final db = await _dbHelper.database;

    // 👉 get today date (YYYY-MM-DD)
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final result = await db.rawQuery(
      '''
      SELECT SUM(total_amount) as total
      FROM sales
      WHERE substr(date, 1, 10) = ?
    ''',
      [today],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // 🧾 RECENT SALES
  Future<List<Map<String, dynamic>>> getRecentSales() async {
    final db = await _dbHelper.database;

    return await db.query('sales', orderBy: 'date DESC', limit: 5);
  }

  Future<List<Map<String, dynamic>>> getAllSales() async {
    final db = await _dbHelper.database;

    final result = await db.query('sales'); // your table name

    return result;
  }
}
