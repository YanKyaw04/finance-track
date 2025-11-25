import 'package:fintrack/core/icons/category_icon.dart';
import 'package:flutter/material.dart';

class CategoryStat {
  final int id;
  final String name;
  String iconKey;
  final double total;
  final double percent;

  CategoryStat({required this.id, required this.name, required this.iconKey, required this.total, required this.percent});
  IconData get icon => CategoryIcons.all[iconKey]!;
}
