import 'package:fintrack/models/transaction.dart';
import 'package:fintrack/repository/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repo = TransactionRepository();

class TransactionNotifier extends Notifier<TransactionState> {
  @override
  TransactionState build() {
    final initial = TransactionState(list: [], isLoading: true);
    Future.microtask(() => _load());
    return initial;
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    final data = await repo.getAll();
    state = state.copyWith(list: data, isLoading: false);
  }

  Future<void> addTransaction(TransactionModel txn) async {
    await repo.add(txn);
    await _load();
  }

  Future<void> updateTransaction(TransactionModel txn) async {
    await repo.update(txn);
    await _load();
  }

  Future<void> deleteTransaction(int id) async {
    await repo.delete(id);
    state = state.copyWith(list: state.list.where((t) => t.id != id).toList());
  }
}

final transactionProvider = NotifierProvider<TransactionNotifier, TransactionState>(() => TransactionNotifier());
