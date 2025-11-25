import 'package:fintrack/models/dashboard.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:fintrack/repository/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepo = TransactionRepository();

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.microtask(() => loadDashboard());
    return DashboardState.initial();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);
    final txns = await transactionRepo.getRecent();
    // final income = txns.where((t) => t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
    // final expense = txns.where((t) => !t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
    final income = await transactionRepo.getIncome();
    final expense = await transactionRepo.getExpense();
    final balance = income - expense;

    state = state.copyWith(isLoading: false, recentTransactions: txns, totalIncome: income, totalExpense: expense, totalBalance: balance);
  }

  Future<void> addTransaction(TransactionModel model) async {
    await transactionRepo.add(model);
    await loadDashboard();
  }

  Future<void> updateTransaction(TransactionModel model) async {
    await transactionRepo.update(model);
    await loadDashboard();
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(() => DashboardNotifier());
