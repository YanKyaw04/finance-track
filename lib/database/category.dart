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
    return await db.update(table, category.toMap(), where: "id = ?", whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await DBHelper().database;
    return await db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  /// Fetch only Income Categories
  Future<List<CategoryModel>> getIncomeCategories() async {
    final db = await DBHelper().database;

    final result = await db.query(table, where: 'isIncome = 1');

    return result.map((map) => CategoryModel.fromMap(map)).toList();
  }

  /// Fetch only Expense Categories
  Future<List<CategoryModel>> getExpenseCategories() async {
    final db = await DBHelper().database;

    final result = await db.query(table, where: 'isIncome = 0');

    return result.map((map) => CategoryModel.fromMap(map)).toList();
  }
}
