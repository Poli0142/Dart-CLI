import 'package:sqflite/sqflite.dart';
import '../../../domain/models/product.dart';
import '../../database.dart';

class ProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.insert('products', product.toMap());
  }

  Future<Product?> getProduct(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<void> updateProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = await _dbHelper.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}