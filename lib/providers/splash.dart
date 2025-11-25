import 'package:fintrack/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/legacy.dart';

final splashProvider = StateProvider.family<bool, BuildContext>((ref, context) {
  Future.delayed(const Duration(seconds: 3), () {
    if (!context.mounted) return;
    context.go(AppRoute.login.path);
  });
  return true;
});
