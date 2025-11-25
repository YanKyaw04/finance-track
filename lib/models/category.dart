import 'package:flutter/material.dart';

class CategoryModel {
  final int? id;
  final String name;
  final IconData? icon;
  final bool isIncome;

  CategoryModel({this.id, required this.name, this.icon, required this.isIncome});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'isIncome': isIncome ? 1 : 0, 'icon': icon?.codePoint};
  }

  static CategoryModel fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      isIncome: map['isIncome'] == 1,
      icon: map['icon'] != null ? IconData(map['icon'], fontFamily: 'MaterialIcons') : null,
    );
  }
}

class CategoryState {
  final List<CategoryModel> list;
  final bool isLoading;

  CategoryState({required this.list, this.isLoading = false});

  CategoryState copyWith({List<CategoryModel>? list, bool? isLoading}) {
    return CategoryState(list: list ?? this.list, isLoading: isLoading ?? this.isLoading);
  }
}
