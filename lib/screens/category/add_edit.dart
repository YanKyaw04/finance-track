import 'package:fintrack/core/icons/category_icon.dart';
import 'package:fintrack/models/category.dart';
import 'package:fintrack/providers/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditCategoryModal extends ConsumerStatefulWidget {
  final CategoryModel? category;

  const AddEditCategoryModal({super.key, this.category});

  @override
  ConsumerState<AddEditCategoryModal> createState() => _AddEditCategoryModalState();
}

class _AddEditCategoryModalState extends ConsumerState<AddEditCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isIncome = true;
  IconData? selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _isIncome = widget.category?.isIncome ?? true;
    selectedIcon = widget.category?.icon ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
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
          key: _formKey,
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
                controller: _nameController,
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
                    final icon = CategoryIcons.all[index];
                    final isSelected = selectedIcon == icon;

                    return GestureDetector(
                      onTap: () => setState(() => selectedIcon = icon),
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
                    selected: _isIncome,
                    selectedColor: Colors.green[400],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(color: _isIncome ? Colors.white : Colors.black87),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    onSelected: (v) => setState(() => _isIncome = true),
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                    selected: !_isIncome,
                    selectedColor: Colors.red[400],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(color: !_isIncome ? Colors.white : Colors.black87),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    onSelected: (v) => setState(() => _isIncome = false),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final model = CategoryModel(
                        id: widget.category?.id,
                        name: _nameController.text.trim(),
                        isIncome: _isIncome,
                        icon: selectedIcon,
                      );

                      if (widget.category == null) {
                        await ref.read(categoryProvider.notifier).addCategory(model);
                      } else {
                        await ref.read(categoryProvider.notifier).updateCategory(model);
                      }

                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: _isIncome ? Colors.green[700] : Colors.red[700],
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
