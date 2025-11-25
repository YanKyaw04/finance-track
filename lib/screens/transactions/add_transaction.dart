import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:fintrack/models/category.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:fintrack/providers/category.dart';
import 'package:fintrack/providers/dashboard.dart';
import 'package:fintrack/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionModal extends ConsumerStatefulWidget {
  final TransactionModel? editTxn;
  final String type;

  const AddTransactionModal({super.key, this.editTxn, this.type = 'both'});

  @override
  ConsumerState<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends ConsumerState<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  double _amount = 0;
  int? _categoryId;
  String? _note;

  @override
  void initState() {
    super.initState();

    // If editing, pre-fill values
    if (widget.editTxn != null) {
      final txn = widget.editTxn!;
      _title = txn.title;
      _amount = txn.amount;
      _categoryId = txn.categoryId;
      _note = txn.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider).list;
    late final List<CategoryModel> filterCategories;

    if (widget.type == 'income') {
      filterCategories = categories.where((c) => c.isIncome == true).toList();
    } else if (widget.type == 'expense') {
      filterCategories = categories.where((c) => c.isIncome == false).toList();
    } else {
      filterCategories = categories;
    }

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Handle
            Container(
              width: 50,
              height: 6,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 20),

            Text(
              widget.editTxn == null ? 'Add Transaction' : 'Edit Transaction',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // TITLE
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    style: AppTextStyles.body,
                    validator: (v) => v!.isEmpty ? 'Enter title' : null,
                    onSaved: (v) => _title = v!,
                  ),
                  const SizedBox(height: 16),

                  // AMOUNT
                  TextFormField(
                    initialValue: _amount == 0 ? '' : _amount.toString(),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.body,
                    validator: (v) => v!.isEmpty ? 'Enter amount' : null,
                    onSaved: (v) => _amount = double.parse(v!),
                  ),
                  const SizedBox(height: 16),

                  // CATEGORY DROPDOWN
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
                    child: DropdownButtonFormField<int>(
                      value: _categoryId,
                      decoration: const InputDecoration(border: InputBorder.none),
                      items: filterCategories.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,

                                backgroundColor: c.isIncome ? Colors.green : Colors.red,
                                child: c.icon != null
                                    ? Icon(c.icon, color: Colors.white, size: 18)
                                    : Text(
                                        c.name[0].toUpperCase(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Text(c.name, style: AppTextStyles.body),
                            ],
                          ),
                        );
                      }).toList(),
                      hint: const Text("Select Category"),
                      onChanged: (v) => setState(() => _categoryId = v),
                      validator: (v) => v == null ? 'Select category' : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CATEGORY BADGE (income/expense)
                  if (_categoryId != null)
                    Builder(
                      builder: (_) {
                        final selected = categories.firstWhere((c) => c.id == _categoryId);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected.isIncome ? Colors.green[50] : Colors.red[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            selected.isIncome ? "Income" : "Expense",
                            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: selected.isIncome ? Colors.green : Colors.red),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  // NOTE FIELD
                  TextFormField(
                    initialValue: _note,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Note (optional)',
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    onSaved: (v) => _note = v,
                  ),
                  const SizedBox(height: 24),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.zero,
                        elevation: 5,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.editTxn == null ? 'Save Transaction' : 'Update Transaction',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final selectedCategory = ref.read(categoryProvider).list.firstWhere((c) => c.id == _categoryId);

    // If EDIT
    if (widget.editTxn != null) {
      final updated = widget.editTxn!.copyWith(
        title: _title,
        amount: _amount,
        categoryId: _categoryId,
        note: _note,
        isIncome: selectedCategory.isIncome,
      );

      await ref.read(transactionProvider.notifier).updateTransaction(updated);
    } else {
      // If NEW
      final newTxn = TransactionModel(
        title: _title,
        amount: _amount,
        categoryId: _categoryId!,
        isIncome: selectedCategory.isIncome,
        date: DateTime.now(),
        note: _note,
      );

      await ref.read(transactionProvider.notifier).addTransaction(newTxn);
    }
    ref.invalidate(dashboardProvider);
    if (mounted) Navigator.pop(context);
  }
}
