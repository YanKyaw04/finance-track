import 'package:fintrack/models/top_category.dart';
import 'package:fintrack/providers/report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';

class TopCategoriesSection extends ConsumerWidget {
  final List<CategoryStat> data;
  final bool isIncome;

  const TopCategoriesSection({super.key, required this.data, required this.isIncome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).toInt()), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Top Categories", style: AppTextStyles.title.copyWith(color: AppColors.textSecondary, fontSize: 18)),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.primary.withAlpha((0.08 * 255).toInt())),
                padding: const EdgeInsets.all(4),
                child: Row(children: [_toggleButton(ref, "Expense", false, isIncome), _toggleButton(ref, "Income", true, isIncome)]),
              ),
            ],
          ),
          const SizedBox(height: 16),

          data.isEmpty
              ? const Padding(padding: EdgeInsets.all(16), child: Text("No category data in this range"))
              : Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: PieChart(PieChartData(sectionsSpace: 3, centerSpaceRadius: 40, sections: _buildChartSections(data))),
                    ),
                    const SizedBox(height: 20),
                    ...data.map(_buildCategoryRow),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _toggleButton(
    WidgetRef ref,
    String label,
    bool sectionType, // true = income, false = expense
    bool currentIsIncome,
  ) {
    final isSelected = (sectionType == currentIsIncome);

    return GestureDetector(
      onTap: () => ref.read(reportProvider.notifier).incomeToggle(sectionType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.primary),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(List<CategoryStat> list) {
    final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];

    return List.generate(list.length, (i) {
      final item = list[i];
      return PieChartSectionData(
        value: item.total,
        color: colors[i % colors.length],
        title: "${item.percent.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    });
  }

  Widget _buildCategoryRow(CategoryStat item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.body),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: item.percent / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.primary,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text("\$${item.total.toStringAsFixed(2)}", style: AppTextStyles.body),
        ],
      ),
    );
  }
}
