import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/core/services/birthday_notification_service.dart';
import 'package:smart_age_calculator_pro/data/repositories/birthday_repository.dart';
import 'package:smart_age_calculator_pro/domain/entities/saved_birthday.dart';

final birthdayRepositoryProvider = Provider<BirthdayRepository>((ref) {
  return BirthdayRepository();
});

final birthdayNotificationServiceProvider =
    Provider<BirthdayNotificationService>((ref) {
  return BirthdayNotificationService();
});

final birthdaysProvider =
    StateNotifierProvider<BirthdaysNotifier, List<SavedBirthday>>((ref) {
  return BirthdaysNotifier(
    ref.read(birthdayRepositoryProvider),
    ref.read(birthdayNotificationServiceProvider),
  );
});

class BirthdaysNotifier extends StateNotifier<List<SavedBirthday>> {
  final BirthdayRepository _repository;
  final BirthdayNotificationService _notificationService;

  BirthdaysNotifier(this._repository, this._notificationService) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final birthdays = await _repository.getAll();
    // Sort by soonest upcoming birthday first.
    birthdays.sort(
      (a, b) => a.daysUntilNextBirthday().compareTo(b.daysUntilNextBirthday()),
    );
    state = birthdays;

    // Re-schedule notifications for the upcoming year every time the
    // list loads (e.g. on app start) so reminders stay accurate.
    await _notificationService.rescheduleAll(birthdays);
  }

  Future<void> addBirthday({
    required String name,
    required DateTime dob,
    required List<int> reminderDaysBefore,
  }) async {
    final newBirthday = SavedBirthday(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      name: name,
      dob: dob,
      reminderDaysBefore: reminderDaysBefore,
    );

    final updated = [...state, newBirthday];
    updated.sort(
      (a, b) => a.daysUntilNextBirthday().compareTo(b.daysUntilNextBirthday()),
    );
    state = updated;

    await _repository.saveAll(updated);
    await _notificationService.scheduleForBirthday(newBirthday);
  }

  Future<void> deleteBirthday(int id) async {
    final toRemove = state.firstWhere((b) => b.id == id);
    final updated = state.where((b) => b.id != id).toList();
    state = updated;

    await _repository.saveAll(updated);
    await _notificationService.cancelForBirthday(toRemove);
  }
}
