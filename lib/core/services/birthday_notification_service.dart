import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:smart_age_calculator_pro/domain/entities/saved_birthday.dart';

/// Handles local notification scheduling for birthday reminders.
///
/// NOTE ON RECURRENCE: flutter_local_notifications does not support a
/// built-in "yearly" recurrence rule, so this service schedules each
/// reminder for its *next* occurrence only. [BirthdayNotificationService.
/// rescheduleAll] is called whenever the saved birthdays list loads (e.g.
/// on app start), which recalculates and re-schedules everything for the
/// upcoming year. As long as the app is opened at least once between
/// reminders, they stay correct automatically.
///
/// NOTE ON ANDROID 13+ PERMISSION: Android 13 (API 33) requires the
/// POST_NOTIFICATIONS runtime permission. This service does not request
/// it automatically to avoid depending on plugin APIs that may not exist
/// across all flutter_local_notifications versions. On first install,
/// if reminders don't appear, the user may need to enable notifications
/// for the app manually in system Settings.
class BirthdayNotificationService {
  static const String _channelId = 'birthday_reminders';
  static const String _channelName = 'Birthday Reminders';
  static const String _channelDescription =
      'Reminders for upcoming birthdays you have saved';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  /// Cancels and re-schedules reminders for a single birthday.
  Future<void> scheduleForBirthday(SavedBirthday birthday) async {
    await cancelForBirthday(birthday);

    final nextBirthday = birthday.nextOccurrence();

    for (var i = 0; i < birthday.reminderDaysBefore.length; i++) {
      final daysBefore = birthday.reminderDaysBefore[i];

      // Fire at 9:00 AM local time, `daysBefore` days before the birthday.
      final notifyDate = DateTime(
        nextBirthday.year,
        nextBirthday.month,
        nextBirthday.day,
      ).subtract(Duration(days: daysBefore)).add(const Duration(hours: 9));

      if (notifyDate.isBefore(DateTime.now())) {
        // This particular reminder's date has already passed for this
        // year's occurrence (e.g. asked for a 7-day reminder but the
        // birthday is only 3 days away) — skip it rather than firing late.
        continue;
      }

      final scheduledDate = tz.TZDateTime.from(notifyDate, tz.local);
      final notificationId = _notificationId(birthday.id, i);

      final body = daysBefore == 0
          ? "It's ${birthday.name}'s birthday today! 🎉"
          : "${birthday.name}'s birthday is in $daysBefore day${daysBefore == 1 ? '' : 's'}!";

      await _plugin.zonedSchedule(
        notificationId,
        'Birthday Reminder',
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelForBirthday(SavedBirthday birthday) async {
    // Reminder day lists are capped at a handful of options in the UI,
    // so cancelling a fixed range of indices safely covers all of them.
    for (var i = 0; i < 10; i++) {
      await _plugin.cancel(_notificationId(birthday.id, i));
    }
  }

  Future<void> rescheduleAll(List<SavedBirthday> birthdays) async {
    for (final birthday in birthdays) {
      await scheduleForBirthday(birthday);
    }
  }

  int _notificationId(int birthdayId, int reminderIndex) {
    return birthdayId * 10 + reminderIndex;
  }
}
