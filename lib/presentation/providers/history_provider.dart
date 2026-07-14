import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/data/repositories/history_repository.dart';
import 'package:smart_age_calculator_pro/domain/entities/history_item.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryItem>>((ref) {
  return HistoryNotifier(ref.read(historyRepositoryProvider));
});

class HistoryNotifier extends StateNotifier<List<HistoryItem>> {
  final HistoryRepository _repository;

  HistoryNotifier(this._repository) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final items = await _repository.getAll();
    // Most recent first.
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> addEntry({
    required String? name,
    required DateTime dob,
    required String summary,
  }) async {
    final entry = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.remainder(1000000),
      name: (name == null || name.trim().isEmpty) ? null : name.trim(),
      dob: dob,
      summary: summary,
      createdAt: DateTime.now(),
    );

    final updated = [entry, ...state];
    state = updated;
    await _repository.saveAll(updated);
  }

  Future<void> deleteEntry(int id) async {
    final updated = state.where((i) => i.id != id).toList();
    state = updated;
    await _repository.saveAll(updated);
  }

  Future<void> clearAll() async {
    state = [];
    await _repository.saveAll([]);
  }

  Future<void> toggleFavorite(int id) async {
    final updated = state
        .map((i) => i.id == id ? i.copyWith(isFavorite: !i.isFavorite) : i)
        .toList();
    state = updated;
    await _repository.saveAll(updated);
  }
}
