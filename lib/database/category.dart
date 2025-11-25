import 'package:fintrack/database/index.dart';
import 'package:fintrack/models/category.dart';

class CategoryHelper {
  final table = "categories";

  Future<int> insert(CategoryModel category) async {
    final db = await DBHelper().database;
    return db.insert(table, category.toMap());
  }

  Future<List<CategoryModel>> getAll() async {
    final db = await DBHelper().database;
    final result = await db.query(table, orderBy: "name ASC");
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await DBHelper().database;
    return await db.update('categories', category.toMap(), where: "id = ?", whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await DBHelper().database;
    return await db.delete('categories', where: "id = ?", whereArgs: [id]);
  }
}
