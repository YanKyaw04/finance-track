import 'package:fintrack/providers/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';

class ReportTopBar extends ConsumerWidget {
  const ReportTopBar({super.key});

  bool isSelected(DateTime from, DateTime to, DateTime sFrom, DateTime sTo) {
    return from.isAtSameMomentAs(sFrom) && to.isAtSameMomentAs(sTo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportProvider);
    final notifier = ref.read(reportProvider.notifier);

    Widget rangeButton({required String label, required VoidCallback onTap, required bool selected}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
            boxShadow: [BoxShadow(color: Colors.white10, blurRadius: 6)],
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: selected ? AppColors.cardLight : AppColors.textSecondary),
          ),
        ),
      );
    }

    final now = DateTime.now();

    //Today
    final todayFrom = DateTime(now.year, now.month, now.day);
    final todayTo = todayFrom.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    //This Week
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekFrom = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekTo = DateTime(now.year, now.month, now.day, 23, 59, 59);

    //This Month
    final monthFrom = DateTime(now.year, now.month, 1);
    final monthTo = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    //Last 30 Days
    final last30To = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final last30From = last30To.subtract(const Duration(days: 30));

    //Custom
    final isCustom =
        !(isSelected(todayFrom, todayTo, state.from, state.to) ||
            isSelected(weekFrom, weekTo, state.from, state.to) ||
            isSelected(monthFrom, monthTo, state.from, state.to) ||
            isSelected(last30From, last30To, state.from, state.to));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              rangeButton(
                label: 'Today',
                selected: isSelected(todayFrom, todayTo, state.from, state.to),
                onTap: () => notifier.setRange(todayFrom, todayTo),
              ),
              const SizedBox(width: 12),
              rangeButton(
                label: 'This Week',
                selected: isSelected(weekFrom, weekTo, state.from, state.to),
                onTap: () => notifier.setRange(weekFrom, weekTo),
              ),
              const SizedBox(width: 12),
              rangeButton(
                label: 'This Month',
                selected: isSelected(monthFrom, monthTo, state.from, state.to),
                onTap: () => notifier.setRange(monthFrom, monthTo),
              ),
              const SizedBox(width: 12),
              rangeButton(
                label: 'Last 30 Days',
                selected: isSelected(last30From, last30To, state.from, state.to),
                onTap: () => notifier.setRange(last30From, last30To),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateRange: DateTimeRange(start: state.from, end: state.to),
                  );
                  if (picked != null) {
                    notifier.setRange(picked.start, picked.end.add(const Duration(hours: 23, minutes: 59, seconds: 59)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCustom ? AppColors.primary : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: isCustom ? Colors.white : AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Custom',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: isCustom ? Colors.white : AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            SummaryChip(label: 'Income', amount: state.income, color: AppColors.success),
            const SizedBox(width: 12),
            SummaryChip(label: 'Expense', amount: state.expense, color: AppColors.error),
            const SizedBox(width: 12),
            PeriodInfoChip(from: state.from, to: state.to),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class SummaryChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const SummaryChip({super.key, required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      height: (MediaQuery.of(context).size.height - 30) / 12,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.body),
          const SizedBox(height: 6),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class PeriodInfoChip extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  const PeriodInfoChip({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    String pretty(DateTime d) => "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      height: (MediaQuery.of(context).size.height - 30) / 12,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Period', style: AppTextStyles.body),
          const SizedBox(height: 2),
          Text('${pretty(from)}\n${pretty(to)}', style: AppTextStyles.body.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
