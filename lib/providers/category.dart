import 'package:fintrack/models/category.dart';
import 'package:fintrack/repository/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repo = CategoryRepository();

class CategoryNotifier extends Notifier<CategoryState> {
  @override
  CategoryState build() {
    final initial = CategoryState(list: [], isLoading: true);
    Future.microtask(() => _load());
    return initial;
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    final data = await repo.getAll();
    state = state.copyWith(isLoading: false, list: data);
  }

  Future<void> addCategory(CategoryModel model) async {
    await repo.insert(model);
    await _load();
  }

  Future<void> updateCategory(CategoryModel model) async {
    await repo.update(model);
    await _load();
  }

  Future<void> deleteCategory(int id) async {
    await repo.delete(id);
    state = state.copyWith(list: state.list.where((c) => c.id != id).toList());
  }
}

final categoryProvider = NotifierProvider<CategoryNotifier, CategoryState>(() => CategoryNotifier());
