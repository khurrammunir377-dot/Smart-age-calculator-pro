import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_age_calculator_pro/domain/entities/history_item.dart';

class HistoryRepository {
  static const _storageKey = 'calculation_history';

  Future<List<HistoryItem>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<HistoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
