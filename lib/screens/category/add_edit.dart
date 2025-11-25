import 'package:fintrack/core/icons/category_icon.dart';
import 'package:fintrack/models/category.dart';
import 'package:fintrack/providers/category.dart';
import 'package:fintrack/providers/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEditCategoryModal extends ConsumerStatefulWidget {
  final CategoryModel? category;

  const AddEditCategoryModal({super.key, this.category});

  @override
  ConsumerState<AddEditCategoryModal> createState() => _AddEditCategoryModalState();
}

class _AddEditCategoryModalState extends ConsumerState<AddEditCategoryModal> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category?.name ?? '');
    // Initialize providers once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isIncomeProvider.notifier).state = widget.category?.isIncome ?? true;
      ref.read(selectedIconKeyProvider.notifier).state = widget.category?.iconKey ?? CategoryIcons.all.keys.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = ref.watch(isIncomeProvider);
    final selectedIconKey = ref.watch(selectedIconKeyProvider);

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 16),
              Text(
                widget.category == null ? 'Add Category' : 'Edit Category',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 24),

              // Name Input
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              // Icon Picker Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Icon",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 65,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoryIcons.all.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final key = CategoryIcons.all.keys.elementAt(index);
                    final icon = CategoryIcons.all[key];

                    final isSelected = key == selectedIconKey;

                    return GestureDetector(
                      onTap: () => ref.read(selectedIconKeyProvider.notifier).state = key,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                        ),
                        child: Icon(icon, size: 30, color: isSelected ? Colors.blue : Colors.black87),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Income / Expense Choice
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Income', style: TextStyle(fontWeight: FontWeight.bold)),
                    selected: isIncome,
                    selectedColor: Colors.green[400],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(color: isIncome ? Colors.white : Colors.black87),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    onSelected: (_) => ref.read(isIncomeProvider.notifier).state = true,
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                    selected: !isIncome,
                    selectedColor: Colors.red[400],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(color: !isIncome ? Colors.white : Colors.black87),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    onSelected: (_) => ref.read(isIncomeProvider.notifier).state = false,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final model = CategoryModel(
                        id: widget.category?.id,
                        name: nameController.text.trim(),
                        isIncome: ref.read(isIncomeProvider),
                        iconKey: ref.read(selectedIconKeyProvider)!,
                      );

                      if (widget.category == null) {
                        await ref.read(categoryProvider.notifier).addCategory(model);
                      } else {
                        await ref.read(categoryProvider.notifier).updateCategory(model);
                      }

                      if (context.mounted) context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: ref.read(isIncomeProvider) ? Colors.green[700] : Colors.red[700],
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: Text(
                    widget.category == null ? 'Add Category' : 'Update Category',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
