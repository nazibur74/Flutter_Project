import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/employee.dart';

class EmployeeService {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insertEmployee(Employee employee) async {
    final db = await _dbHelper.database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('employees');

    return List.generate(maps.length, (i) {
      return Employee(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        dob: maps[i]['dob'] as String,
        phone: maps[i]['phone'] as String,
        email: maps[i]['email'] as String,
        nid: maps[i]['nid'] as String,
        role: maps[i]['role'] as String,
        address: maps[i]['address'] as String,
      );
    });
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await _dbHelper.database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id=?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('employees', where: 'id=?', whereArgs: [id]);
  }

  Future<int> getEmployeeCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM employees');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
