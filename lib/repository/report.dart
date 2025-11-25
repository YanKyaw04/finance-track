import 'package:fintrack/database/report.dart';

class ReportRepository {
  final _helper = ReportHelper();
  Future<Map<String, double>> fetchIncomeExpense(DateTime from, DateTime to) => _helper.getIncomeExpenseBetween(from, to);

  Future<List<Map<String, dynamic>>> fetchRecentTransactions({required DateTime from, required DateTime to, int limit = 10}) =>
      _helper.getRecentTransactions(from: from, to: to, limit: limit);

  Future<List<Map<String, dynamic>>> fetchMonthlyNet(int year) => _helper.getMonthlyNetForYear(year);

  Future<List<Map<String, dynamic>>> fetchTopCategories({required DateTime from, required DateTime to, required String type, int limit = 5}) =>
      _helper.getTopCategories(from: from, to: to, type: type, limit: limit);
}
