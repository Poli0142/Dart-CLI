import 'package:sqflite/sqflite.dart';
import '../../../domain/models/role.dart';
import '../../database.dart';

class RoleRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertRole(Role role) async {
    final db = await _dbHelper.database;
    await db.insert('roles', role.toMap());
  }

  Future<Role?> getRole(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'roles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Role.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Role>> getAllRoles() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('roles');
    return maps.map((map) => Role.fromMap(map)).toList();
  }

  Future<void> updateRole(Role role) async {
    final db = await _dbHelper.database;
    await db.update(
      'roles',
      role.toMap(),
      where: 'id = ?',
      whereArgs: [role.id],
    );
  }

  Future<void> deleteRole(String id) async {
    final db = await _dbHelper.database;
    await db.delete('roles', where: 'id = ?', whereArgs: [id]);
  }
}