import 'package:fintrack/database/category.dart';
import 'package:fintrack/models/category.dart';

class CategoryRepository {
  final _helper = CategoryHelper();

  Future<List<CategoryModel>> getAll() => _helper.getAll();
  Future<int> insert(CategoryModel model) => _helper.insert(model);
  Future<int> update(CategoryModel model) => _helper.updateCategory(model);
  Future<int> delete(int id) => _helper.deleteCategory(id);
}
