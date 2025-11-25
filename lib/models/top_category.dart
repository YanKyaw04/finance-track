import 'package:flutter/material.dart';

class CategoryStat {
  final int id;
  final String name;
  IconData? icon;
  final double total;
  final double percent;

  CategoryStat({required this.id, required this.name, this.icon, required this.total, required this.percent});
}
