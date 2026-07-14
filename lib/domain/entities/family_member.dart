class FamilyMember {
  final int id;
  final String name;
  final DateTime dob;
  final String? gender;
  final String relationship;
  final String? photoPath;

  FamilyMember({
    required this.id,
    required this.name,
    required this.dob,
    this.gender,
    required this.relationship,
    this.photoPath,
  });

  FamilyMember copyWith({
    String? name,
    DateTime? dob,
    String? gender,
    String? relationship,
    String? photoPath,
  }) {
    return FamilyMember(
      id: id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      relationship: relationship ?? this.relationship,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  int get ageInYears {
    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

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
        'gender': gender,
        'relationship': relationship,
        'photoPath': photoPath,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as int,
      name: json['name'] as String,
      dob: DateTime.parse(json['dob'] as String),
      gender: json['gender'] as String?,
      relationship: json['relationship'] as String,
      photoPath: json['photoPath'] as String?,
    );
  }
}
