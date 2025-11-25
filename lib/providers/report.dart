import 'package:fintrack/models/report.dart';
import 'package:fintrack/repository/report.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportRepo = ReportRepository();

class ReportNotifier extends Notifier<ReportState> {
  @override
  ReportState build() {
    Future.microtask(() async {
      await load();
    });

    return ReportState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final from = state.from;
    final to = state.to;
    final ie = await reportRepo.fetchIncomeExpense(from, to);
    final recent = await reportRepo.fetchRecentTransactions(from: from, to: to, limit: 8);
    final topExpenses = await reportRepo.fetchTopCategories(from: from, to: to, type: 'expense', limit: 5);
    final topIncomes = await reportRepo.fetchTopCategories(from: from, to: to, type: 'income', limit: 5);
    final monthlyNet = await reportRepo.fetchMonthlyNet(DateTime.now().year);

    state = state.copyWith(
      isLoading: false,
      income: ie['income'] ?? 0,
      expense: ie['expense'] ?? 0,
      recent: recent,
      topExpenses: topExpenses,
      topIncomes: topIncomes,
      monthlyNet: monthlyNet,
    );
  }

  Future<void> setRange(DateTime from, DateTime to) async {
    state = state.copyWith(from: from, to: to);
    await load();
  }

  Future<void> refresh() async {
    await load();
  }
}

final reportProvider = NotifierProvider<ReportNotifier, ReportState>(() => ReportNotifier());
