import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';

class IncomeExpenseRadial extends ConsumerWidget {
  final double income;
  final double expense;

  const IncomeExpenseRadial({super.key, required this.income, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = max(income + expense, 1);
    final incomePercent = (income / total);
    final expensePercent = (expense / total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRadialCard("Income", income, incomePercent, AppColors.success),
        _buildRadialCard("Expense", expense, expensePercent, AppColors.error),
      ],
    );
  }

  Widget _buildRadialCard(String label, double amount, double percent, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.cardLight.withAlpha((0.4 * 255).toInt()), // replaced with withAlpha
          border: Border.all(color: AppColors.primary.withAlpha((0.2 * 255).toInt())), // replaced with withAlpha
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()), // subtle shadow
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 12,
                    backgroundColor: color.withAlpha((0.2 * 255).toInt()), // replaced with withAlpha
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Text("${(percent * 100).toStringAsFixed(0)}%", style: AppTextStyles.amount.copyWith(fontSize: 18, color: color)),
              ],
            ),
            const SizedBox(height: 12),
            Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("${amount.toStringAsFixed(0)} Ks", style: AppTextStyles.amount.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
