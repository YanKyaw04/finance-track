class ReportState {
  final bool isLoading;
  final double income;
  final double expense;
  final List<Map<String, dynamic>> recent;
  final List<Map<String, dynamic>> monthlyNet; // list of {month, net}
  final List<Map<String, dynamic>> topExpenses;
  final List<Map<String, dynamic>> topIncomes;
  final DateTime from;
  final DateTime to;

  ReportState({
    required this.isLoading,
    required this.income,
    required this.expense,
    required this.recent,
    required this.monthlyNet,
    required this.topExpenses,
    required this.topIncomes,
    required this.from,
    required this.to,
  });

  ReportState copyWith({
    bool? isLoading,
    double? income,
    double? expense,
    List<Map<String, dynamic>>? recent,
    List<Map<String, dynamic>>? monthlyNet,
    List<Map<String, dynamic>>? topExpenses,
    List<Map<String, dynamic>>? topIncomes,
    DateTime? from,
    DateTime? to,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      recent: recent ?? this.recent,
      monthlyNet: monthlyNet ?? this.monthlyNet,
      topExpenses: topExpenses ?? this.topExpenses,
      topIncomes: topIncomes ?? this.topIncomes,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  factory ReportState.initial({DateTime? from, DateTime? to}) {
    final now = DateTime.now();
    final start = from ?? DateTime(now.year, now.month, 1);
    final end = to ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return ReportState(isLoading: false, income: 0, expense: 0, recent: [], monthlyNet: [], topExpenses: [], topIncomes: [], from: start, to: end);
  }
}
