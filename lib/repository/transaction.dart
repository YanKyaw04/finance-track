import 'package:fintrack/database/transaction.dart';
import 'package:fintrack/models/transaction.dart';

class TransactionRepository {
  final _helper = TransactionHelper();

  Future<int> add(TransactionModel t) => _helper.insert(t);

  Future<List<TransactionModel>> getAll() => _helper.getAll();

  Future<List<TransactionModel>> getRecent() => _helper.getRecent();

  Future<double> getIncome() => _helper.getTotalIncome();

  Future<double> getExpense() => _helper.getTotalExpense();

  Future<int> update(TransactionModel data) => _helper.update(data);

  Future<int> delete(int id) => _helper.delete(id);
}
