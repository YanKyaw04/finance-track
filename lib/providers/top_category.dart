import 'package:fintrack/database/index.dart';
import 'package:fintrack/models/top_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final topCategoriesProvider = FutureProvider.autoDispose.family<List<CategoryStat>, ({DateTime from, DateTime to, bool isIncome})>((ref, args) async {
  final db = await DBHelper().database;

  // First: total of all categories (for percentage)
  final totalRow = await db.rawQuery(
    '''
    SELECT SUM(amount) AS total
    FROM transactions
    WHERE isIncome = ?
    AND date BETWEEN ? AND ?
  ''',
    [args.isIncome ? 1 : 0, args.from.toIso8601String(), args.to.toIso8601String()],
  );

  final totalAmount = (totalRow.first['total'] as num?)?.toDouble() ?? 0;

  // No data case
  if (totalAmount == 0) return [];

  // Fetch category-wise breakdown
  final rows = await db.rawQuery(
    '''
    SELECT c.id, c.name, c.icon,
      SUM(t.amount) AS total
    FROM transactions t
    JOIN categories c ON c.id = t.categoryId
    WHERE t.isIncome = ?
    AND t.date BETWEEN ? AND ?
    GROUP BY c.id
    ORDER BY total DESC
  ''',
    [args.isIncome ? 1 : 0, args.from.toIso8601String(), args.to.toIso8601String()],
  );

  return rows.map((r) {
    final amount = (r['total'] as num).toDouble();
    final percent = (amount / totalAmount) * 100;

    return CategoryStat(
      id: r['id'] as int,
      name: r['name'] as String,
      icon: r['icon'] != null ? IconData(r['icon'] as int, fontFamily: 'MaterialIcons') : null,
      total: amount,
      percent: percent,
    );
  }).toList();
});
