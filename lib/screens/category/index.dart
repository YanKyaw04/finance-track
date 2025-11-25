import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/providers/category.dart';
import 'package:fintrack/screens/category/add_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: state.list.isEmpty
          ? Center(
              child: Text('No categories yet', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              primary: false,
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final category = state.list[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: Key(category.id.toString()),
                    background: _slideLeftBackground(),
                    secondaryBackground: _slideRightBackground(),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Swipe Right → Edit

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddEditCategoryModal(category: category),
                        );
                        return false; // don't dismiss
                      } else {
                        // Swipe Left → Delete
                        final confirmed = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this category?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ref.read(categoryProvider.notifier).deleteCategory(category.id!);
                          return true;
                        }
                        return false;
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: category.isIncome ? Colors.green[400] : Colors.red[400],
                          child: Icon(category.icon, color: Colors.white, size: 24),
                        ),
                        title: Text(category.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          category.isIncome ? 'Income' : 'Expense',
                          style: TextStyle(color: category.isIncome ? Colors.green : Colors.red[700], fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddEditCategoryModal(),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Swipe Right → Edit
  Widget _slideLeftBackground() {
    return Container(
      padding: const EdgeInsets.only(left: 24),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: const [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Edit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Swipe Left → Delete
  Widget _slideRightBackground() {
    return Container(
      padding: const EdgeInsets.only(right: 24),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
