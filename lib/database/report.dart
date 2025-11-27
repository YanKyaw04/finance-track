import 'package:fintrack/database/index.dart';
import 'package:fintrack/models/top_category.dart';

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

  // Future<List<Map<String, dynamic>>> getTopCategories({required DateTime from, required DateTime to, required bool isIncome, int limit = 5}) async {
  //   final db = await DBHelper().database;

  //   final rows = await db.rawQuery(
  //     '''
  //     SELECT c.id as categoryId, c.name as categoryName, c.iconKey as categoryIcon,
  //            SUM(t.amount) as total
  //     FROM transactions t
  //     JOIN categories c ON t.categoryId = c.id
  //     WHERE t.isIncome = ? AND t.date BETWEEN ? AND ?
  //     GROUP BY t.categoryId
  //     ORDER BY total DESC
  //     LIMIT ?
  //     ''',
  //     [isIncome, from.toIso8601String(), to.toIso8601String(), limit],
  //   );
  //   return rows;
  // }

  //final topCategoriesProvider = FutureProvider.autoDispose.family<List<CategoryStat>, ({DateTime from, DateTime to, bool isIncome})>((ref, args) async {
  Future<List<CategoryStat>> getTopCategories({required DateTime from, required DateTime to, required bool isIncome, int limit = 5}) async {
    final db = await DBHelper().database;

    final f = from.toIso8601String();
    final t = to.toIso8601String();

    // First: total of all categories (for percentage)
    final totalRow = await db.rawQuery(
      '''
    SELECT SUM(amount) AS total
    FROM transactions
    WHERE isIncome = ?
    AND date BETWEEN ? AND ?
   
  ''',
      [isIncome ? 1 : 0, f, t],
    );

    final totalAmount = (totalRow.first['total'] as num?)?.toDouble() ?? 0;

    if (totalAmount == 0) return [];

    // Fetch category-wise breakdown
    final rows = await db.rawQuery(
      '''
    SELECT c.id, c.name, c.iconKey,
      SUM(t.amount) AS total
    FROM transactions t
    JOIN categories c ON c.id = t.categoryId
    WHERE t.isIncome = ?
    AND t.date BETWEEN ? AND ?
    GROUP BY c.id
    ORDER BY total DESC
  ''',
      [isIncome ? 1 : 0, f, t],
    );

    return rows.map((r) {
      final amount = (r['total'] as num).toDouble();
      final percent = (amount / totalAmount) * 100;
      return CategoryStat(id: r['id'] as int, name: r['name'] as String, iconKey: r['iconKey'] as String, total: amount, percent: percent);
    }).toList();
  }
}
