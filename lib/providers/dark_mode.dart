import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isDarkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) => DarkModeNotifier());

class DarkModeNotifier extends StateNotifier<bool> {
  static const String _key = 'isDarkMode';

  DarkModeNotifier() : super(false) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }

  Future<void> setDarkMode(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
