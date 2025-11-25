import 'package:fintrack/repository/currency.dart';
import 'package:flutter_riverpod/legacy.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('USD') {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final saved = await CurrencyRepository.getCurrency();
    if (saved != null) state = saved;
  }

  Future<void> setCurrency(String code) async {
    state = code;
    await CurrencyRepository.saveCurrency(code);
  }
}
