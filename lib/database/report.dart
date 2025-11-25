import 'package:fintrack/database/index.dart';

class ReportHelper {
  /// Returns total income and total expense for date range [from]..[to]
  Future<Map<String, double>> getIncomeExpenseBetween(DateTime from, DateTime to) async {
    final db = await DBHelper().database;

    final fromIso = from.toIso8601String();
    final toIso = to.toIso8601String();

    // Use SUM with isIncome flag
    final incomeRes = await db.rawQuery(
      '''SELECT IFNULL(SUM(amount),0) as total
         FROM transactions
         WHERE isIncome = 1 AND date BETWEEN ? AND ?''',
      [fromIso, toIso],
    );

    final expenseRes = await db.rawQuery(
      '''SELECT IFNULL(SUM(amount),0) as total
         FROM transactions
         WHERE isIncome = 0 AND date BETWEEN ? AND ?''',
      [fromIso, toIso],
    );

    final income = (incomeRes.first['total'] ?? 0) as num;
    final expense = (expenseRes.first['total'] ?? 0) as num;

    return {'income': income.toDouble(), 'expense': expense.toDouble()};
  }

  /// Returns latest N transactions in the date range (ordered desc)
  Future<List<Map<String, dynamic>>> getRecentTransactions({required DateTime from, required DateTime to, int limit = 10}) async {
    final db = await DBHelper().database;

    final rows = await db.rawQuery(
      '''
      SELECT t.*, c.name as categoryName, c.iconKey as categoryIcon, c.isIncome as categoryIsIncome
      FROM transactions t
      LEFT JOIN categories c ON t.categoryId = c.id
      WHERE t.date BETWEEN ? AND ?
      ORDER BY t.date DESC
      LIMIT ?
      ''',
      [from.toIso8601String(), to.toIso8601String(), limit],
    );
    return rows;
  }

  /// Returns monthly net totals for the given year (map month -> net amount)
  Future<List<Map<String, dynamic>>> getMonthlyNetForYear(int year) async {
    // Group by month
    final db = await DBHelper().database;

    final from = DateTime(year, 1, 1).toIso8601String();
    final to = DateTime(year, 12, 31, 23, 59, 59).toIso8601String();

    final rows = await db.rawQuery(
      '''
      SELECT CAST(strftime('%m', date) AS INTEGER) as month,
             SUM(CASE WHEN isIncome = 1 THEN amount ELSE -amount END) as net
      FROM transactions
      WHERE date BETWEEN ? AND ?
      GROUP BY month
      ORDER BY month
      ''',
      [from, to],
    );
    // rows: [{month: 1, net: 123.4}, ...]
    return rows;
  }

  /// Returns top categories by expense or income in the range
  /// type: 'income' or 'expense'
  Future<List<Map<String, dynamic>>> getTopCategories({required DateTime from, required DateTime to, required String type, int limit = 5}) async {
    final isIncomeFlag = (type == 'income') ? 1 : 0;
    final db = await DBHelper().database;

    final rows = await db.rawQuery(
      '''
      SELECT c.id as categoryId, c.name as categoryName, c.iconKey as categoryIcon, 
             SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE t.isIncome = ? AND t.date BETWEEN ? AND ?
      GROUP BY t.categoryId
      ORDER BY total DESC
      LIMIT ?
      ''',
      [isIncomeFlag, from.toIso8601String(), to.toIso8601String(), limit],
    );
    return rows;
  }
}
