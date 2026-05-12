import 'package:sqflite/sqflite.dart';
import '../../../domain/models/order.dart';
import '../../database.dart';

class OrderRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertOrder(Order order) async {
    final db = await _dbHelper.database;
    await db.insert('orders', order.toMap());
  }

  Future<Order?> getOrder(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Order>> getAllOrders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<void> updateOrder(Order order) async {
    final db = await _dbHelper.database;
    await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<void> deleteOrder(String id) async {
    final db = await _dbHelper.database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}