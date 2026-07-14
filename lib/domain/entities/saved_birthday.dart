class SavedBirthday {
  final int id;
  final String name;
  final DateTime dob;
  final List<int> reminderDaysBefore; // e.g. [1, 3, 7]

  SavedBirthday({
    required this.id,
    required this.name,
    required this.dob,
    required this.reminderDaysBefore,
  });

  SavedBirthday copyWith({
    String? name,
    DateTime? dob,
    List<int>? reminderDaysBefore,
  }) {
    return SavedBirthday(
      id: id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    );
  }

  /// The next occurrence of this birthday from [from] (defaults to now).
  DateTime nextOccurrence({DateTime? from}) {
    final now = from ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(today.year, dob.month, dob.day);
    if (next.isBefore(today)) {
      next = DateTime(today.year + 1, dob.month, dob.day);
    }
    return next;
  }

  int daysUntilNextBirthday({DateTime? from}) {
    final now = from ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return nextOccurrence(from: now).difference(today).inDays;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dob': dob.toIso8601String(),
        'reminderDaysBefore': reminderDaysBefore,
      };

  factory SavedBirthday.fromJson(Map<String, dynamic> json) {
    return SavedBirthday(
      id: json['id'] as int,
      name: json['name'] as String,
      dob: DateTime.parse(json['dob'] as String),
      reminderDaysBefore: (json['reminderDaysBefore'] as List)
          .map((e) => e as int)
          .toList(),
    );
  }
}
