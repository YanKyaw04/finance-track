import 'package:fintrack/database/report.dart';
import 'package:fintrack/models/top_category.dart';

class ReportRepository {
  final _helper = ReportHelper();
  Future<Map<String, double>> fetchIncomeExpense(DateTime from, DateTime to) => _helper.getIncomeExpenseBetween(from, to);

  Future<List<CategoryStat>> fetchTopCategories({required DateTime from, required DateTime to, required bool isIncome, int limit = 5}) =>
      _helper.getTopCategories(from: from, to: to, isIncome: isIncome, limit: limit);
}
