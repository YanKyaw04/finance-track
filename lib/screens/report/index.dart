import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/providers/report.dart';
import 'package:fintrack/screens/report/income_expense_trend.dart';
import 'package:fintrack/screens/report/top_bar.dart';
import 'package:fintrack/screens/report/top_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReportTopBar(),

                  const SizedBox(height: 12),
                  IncomeExpenseRadial(income: state.income, expense: state.expense),

                  const SizedBox(height: 16),
                  TopCategoriesSection(from: state.from, to: state.to),
                ],
              ),
      ),
    );
  }
}
