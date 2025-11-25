// ignore_for_file: public_member_api_docs, sort_constructors_first
class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final int categoryId;
  final bool isIncome;
  final String? note;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.isIncome,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
      'isIncome': isIncome ? 1 : 0,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      categoryId: map['categoryId'],
      isIncome: map['isIncome'] == 1,
      note: map['note'],
    );
  }

  TransactionModel copyWith({int? id, String? title, double? amount, DateTime? date, int? categoryId, bool? isIncome, String? note}) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      isIncome: isIncome ?? this.isIncome,
      note: note ?? this.note,
    );
  }
}

class TransactionState {
  final List<TransactionModel> list;
  final bool isLoading;

  TransactionState({required this.list, this.isLoading = false});

  TransactionState copyWith({List<TransactionModel>? list, bool? isLoading}) {
    return TransactionState(list: list ?? this.list, isLoading: isLoading ?? this.isLoading);
  }
}
