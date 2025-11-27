import 'package:fintrack/models/top_category.dart';

class ReportState {
  final bool isLoading;
  final bool isIncome;
  final double income;
  final double expense;
  final List<CategoryStat> topCategories;
  final DateTime from;
  final DateTime to;

  ReportState({
    required this.isLoading,
    required this.income,
    required this.isIncome,
    required this.expense,
    required this.topCategories,
    required this.from,
    required this.to,
  });

  ReportState copyWith({
    bool? isLoading,
    bool? isIncome,
    double? income,
    double? expense,
    List<CategoryStat>? topCategories,
    DateTime? from,
    DateTime? to,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      isIncome: isIncome ?? this.isIncome,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      topCategories: topCategories ?? this.topCategories,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  factory ReportState.initial({DateTime? from, DateTime? to}) {
    final now = DateTime.now();
    final start = from ?? DateTime(now.year, now.month, 1);
    final end = to ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return ReportState(isLoading: false, isIncome: false, income: 0, expense: 0, topCategories: [], from: start, to: end);
  }
}
