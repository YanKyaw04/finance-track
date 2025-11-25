import 'package:shared_preferences/shared_preferences.dart';

class CurrencyRepository {
  static const _keyCurrency = 'selected_currency';

  static Future<void> saveCurrency(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, code);
  }

  static Future<String?> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrency);
  }
}
