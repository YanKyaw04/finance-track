import 'package:flutter_riverpod/legacy.dart';

final homeTabProvider = StateProvider<int>((ref) => 0);

enum ReportRange { today, last7Days, thisMonth, last6Months }

final reportRangeProvider = StateProvider<ReportRange>((ref) => ReportRange.today);

final selectedIconKeyProvider = StateProvider<String?>((ref) => null);
final isIncomeProvider = StateProvider<bool>((ref) => false);
