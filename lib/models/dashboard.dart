import 'package:fintrack/models/transaction.dart';

class DashboardState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<TransactionModel> recentTransactions;
  final bool isLoading;

  DashboardState({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.recentTransactions,
    this.isLoading = false,
  });

  DashboardState copyWith({
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    List<TransactionModel>? recentTransactions,
    bool? isLoading,
  }) {
    return DashboardState(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory DashboardState.initial() {
    return DashboardState(totalBalance: 0, totalIncome: 0, totalExpense: 0, recentTransactions: []);
  }
}
