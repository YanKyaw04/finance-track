import 'package:fintrack/core/icons/category_icon.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final int? id;
  final String name;
  final String iconKey;
  final bool isIncome;

  CategoryModel({this.id, required this.name, required this.iconKey, required this.isIncome});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'iconKey': iconKey, 'isIncome': isIncome ? 1 : 0};
  }

  /// ---- LOAD FROM DATABASE ----
  static CategoryModel fromMap(Map<String, dynamic> map) {
    return CategoryModel(id: map['id'] as int?, name: map['name'] ?? '', iconKey: map['iconKey'] ?? 'category', isIncome: map['isIncome'] == 1);
  }

  IconData get icon => CategoryIcons.all[iconKey]!;
}

class CategoryState {
  final List<CategoryModel> list;
  final bool isLoading;

  CategoryState({required this.list, this.isLoading = false});

  CategoryState copyWith({List<CategoryModel>? list, bool? isLoading}) {
    return CategoryState(list: list ?? this.list, isLoading: isLoading ?? this.isLoading);
  }
}
