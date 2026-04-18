import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/supplier.dart';

class SupplierService {
  final DBHelper _dbHelper = DBHelper();

  // INSERT
  Future<int> insertSupplier(Supplier supplier) async {
    final db = await _dbHelper.database;
    return await db.insert('suppliers', supplier.toMap());
  }

  // GET ALL (RETURN MODEL LIST)
  Future<List<Supplier>> getAllSuppliers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('suppliers');

    return List.generate(maps.length, (i) {
      return Supplier(
        id: maps[i]['id'],
        name: maps[i]['name'],
        company: maps[i]['company'],
        phone: maps[i]['phone'],
        address: maps[i]['address'],
      );
    });
  }

  // UPDATE
  Future<int> updateSupplier(Supplier supplier) async {
    final db = await _dbHelper.database;
    return await db.update(
      'suppliers',
      supplier.toMap(),
      where: 'id=?',
      whereArgs: [supplier.id],
    );
  }

  // DELETE
  Future<int> deleteSupplier(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('suppliers', where: 'id=?', whereArgs: [id]);
  }

  Future<int> getSupplierCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM suppliers');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
