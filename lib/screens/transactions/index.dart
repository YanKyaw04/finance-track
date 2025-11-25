import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:fintrack/providers/transactions.dart';
import 'package:fintrack/screens/transactions/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTransactionModal(),
          );
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.list.isEmpty
          ? Center(
              child: Text('No transactions yet', style: AppTextStyles.body.copyWith(color: Colors.grey[500])),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              primary: false,
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final txn = state.list[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Dismissible(
                    key: Key(txn.id.toString()),
                    background: _dismissAction(alignment: Alignment.centerLeft, icon: Icons.edit, color: AppColors.primary),
                    secondaryBackground: _dismissAction(alignment: Alignment.centerRight, icon: Icons.delete, color: Colors.red),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddTransactionModal(editTxn: txn),
                        );
                        return false;
                      } else {
                        final confirmed = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure to delete this transaction?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ref.read(transactionProvider.notifier).deleteTransaction(txn.id!);
                        }
                        return confirmed;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).toInt()), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: txn.isIncome ? AppColors.success : AppColors.error,
                            child: Icon(txn.isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(txn.title, style: AppTextStyles.body.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(txn.note ?? '', style: AppTextStyles.body.copyWith(fontSize: 12, color: Colors.grey.shade600)),
                                const SizedBox(height: 4),
                                Text(
                                  '${txn.date.toLocal()}'.split(' ')[0],
                                  style: AppTextStyles.body.copyWith(fontSize: 12, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '\$${txn.amount.toStringAsFixed(2)}',
                            style: AppTextStyles.amount.copyWith(
                              color: txn.isIncome ? AppColors.success : AppColors.error,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Dismiss background helper
  Widget _dismissAction({required Alignment alignment, required IconData icon, required Color color}) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Icon(icon, color: Colors.white),
    );
  }
}
