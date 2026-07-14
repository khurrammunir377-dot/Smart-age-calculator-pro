class HistoryItem {
  final int id;
  final String? name;
  final DateTime dob;
  final String summary;
  final DateTime createdAt;
  final bool isFavorite;

  HistoryItem({
    required this.id,
    this.name,
    required this.dob,
    required this.summary,
    required this.createdAt,
    this.isFavorite = false,
  });

  HistoryItem copyWith({
    String? name,
    DateTime? dob,
    String? summary,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return HistoryItem(
      id: id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dob': dob.toIso8601String(),
        'summary': summary,
        'createdAt': createdAt.toIso8601String(),
        'isFavorite': isFavorite,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as int,
      name: json['name'] as String?,
      dob: DateTime.parse(json['dob'] as String),
      summary: json['summary'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
