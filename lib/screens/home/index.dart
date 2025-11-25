import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:fintrack/providers/common.dart';
import 'package:fintrack/providers/dashboard.dart';
import 'package:fintrack/screens/transactions/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const AddTransactionModal(),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, size: 32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(50), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Balance", style: AppTextStyles.body.copyWith(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text("\$${data.totalBalance.toStringAsFixed(2)}", style: AppTextStyles.amount.copyWith(color: Colors.white, fontSize: 28)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IncomeExpenseTile(label: "Income", amount: data.totalIncome, color: AppColors.success),
                      _IncomeExpenseTile(label: "Expense", amount: data.totalExpense, color: AppColors.error),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickActionCard(
                  label: "Add Income",
                  icon: Icons.arrow_downward,
                  color: AppColors.success,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => const AddTransactionModal(type: 'income'),
                    );
                  },
                ),
                _QuickActionCard(
                  label: "Add Expense",
                  icon: Icons.arrow_upward,
                  color: AppColors.error,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => const AddTransactionModal(type: 'expense'),
                    );
                  },
                ),
                _QuickActionCard(
                  label: "Reports",
                  icon: Icons.bar_chart,
                  color: AppColors.primary,
                  onTap: () => ref.read(homeTabProvider.notifier).state = 2,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Transactions", style: AppTextStyles.sectionTitle),
                TextButton(onPressed: () => ref.read(homeTabProvider.notifier).state = 1, child: const Text("See All")),
              ],
            ),
            const SizedBox(height: 8),

            // Transactions List
            data.recentTransactions.isEmpty
                ? const Center(child: Text("No transactions yet"))
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.recentTransactions.length,
                    itemBuilder: (context, index) {
                      final t = data.recentTransactions[index];
                      return Card(
                        color: AppColors.cardLight,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: t.isIncome ? AppColors.success : AppColors.error,
                            child: Icon(t.isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
                          ),
                          title: Text(t.title, style: AppTextStyles.body),
                          trailing: Text(
                            "\$${t.amount.toStringAsFixed(2)}",
                            style: AppTextStyles.amount.copyWith(color: t.isIncome ? AppColors.success : AppColors.error),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

// Income & Expense Tile
class _IncomeExpenseTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _IncomeExpenseTile({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: Colors.white70)),
        const SizedBox(height: 4),
        Text("\$${amount.toStringAsFixed(2)}", style: AppTextStyles.amount.copyWith(color: color, fontSize: 16)),
      ],
    );
  }
}

// Quick Action Card
class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 3,
        height: (MediaQuery.of(context).size.height - 30) / 7,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
