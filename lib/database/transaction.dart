import 'package:fintrack/database/index.dart';
import 'package:fintrack/models/transaction.dart';

class TransactionHelper {
  final table = "transactions";

  Future<int> insert(TransactionModel t) async {
    final db = await DBHelper().database;
    return db.insert(table, t.toMap());
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await DBHelper().database;
    final result = await db.query(table, orderBy: "date DESC");
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<List<TransactionModel>> getRecent() async {
    final db = await DBHelper().database;
    final result = await db.query(table, orderBy: "date DESC", limit: 5);
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<double> getTotalIncome() async {
    final db = await DBHelper().database;
    final result = await db.rawQuery('''
      SELECT SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE c.isIncome = 1
    ''');

    final value = result.first["total"];
    return (value == null) ? 0 : value as double;
  }

  Future<double> getTotalExpense() async {
    final db = await DBHelper().database;
    final result = await db.rawQuery('''
      SELECT SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE c.isIncome = 0
    ''');

    final value = result.first["total"];
    return (value == null) ? 0 : value as double;
  }

  Future<int> update(TransactionModel txn) async {
    final db = await DBHelper().database;
    return await db.update('transactions', txn.toMap(), where: 'id = ?', whereArgs: [txn.id]);
  }

  Future<int> delete(int id) async {
    final db = await DBHelper().database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
