import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_age_calculator_pro/domain/entities/saved_birthday.dart';

class BirthdayRepository {
  static const _storageKey = 'saved_birthdays';

  Future<List<SavedBirthday>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => SavedBirthday.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<SavedBirthday> birthdays) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(birthdays.map((b) => b.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
