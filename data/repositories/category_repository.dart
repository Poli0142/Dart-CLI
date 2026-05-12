import 'package:sqflite/sqflite.dart';
import '../../../domain/models/category.dart';
import '../../database.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertCategory(Category category) async {
    final db = await _dbHelper.database;
    await db.insert('categories', category.toMap());
  }

  Future<Category?> getCategory(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Category>> getAllCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  Future<void> updateCategory(Category category) async {
    final db = await _dbHelper.database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await _dbHelper.database;
    final products = await db.query('products', where: 'categoryId = ?', whereArgs: [id]);
    if (products.isNotEmpty) {
      throw Exception('Нельзя удалить категорию, в которой есть товары');
    }
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}